<?php

require_once('api/Simpla.php');


############################################
# Class Category - Edit the good gategory
############################################
class CategoryAdmin extends Simpla
{
  private	$allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
  
  function fetch()
  {
		$category = new stdClass;
		if($this->request->method('post'))
		{
			$category->id = $this->request->post('id', 'integer');
			$category->parent_id = $this->request->post('parent_id', 'integer');
			$category->name = $this->request->post('name');
			$category->visible = $this->request->post('visible', 'boolean');
			$category->clear = $this->request->post('clear', 'boolean');
			$category->show_products = $this->request->post('show_products', 'boolean');
			$category->group_options_in_price = $this->request->post('group_options_in_price', 'boolean');

			$category->url = $this->request->post('url', 'string');
			$category->meta_title = $this->request->post('meta_title');
			$category->meta_keywords = $this->request->post('meta_keywords');
			$category->meta_description = $this->request->post('meta_description');
			
			$category->description = $this->request->post('description');
	
			// Не допустить одинаковые URL разделов.
			if(($c = $this->categories->get_category($category->url)) && $c->id!=$category->id)
			{			
				$this->design->assign('message_error', 'url_exists');
			}
			else
			{
				if(empty($category->id))
				{
	  				$category->id = $this->categories->add_category($category);
					$this->design->assign('message_success', 'added');
	  			}
  	    		else
  	    		{
  	    			$this->categories->update_category($category->id, $category);
					$this->design->assign('message_success', 'updated');
  	    		}
  	    		// Удаление изображения
  	    		if($this->request->post('delete_image'))
  	    		{
  	    			$this->categories->delete_image($category->id);
  	    		}
  	    		// Загрузка изображения
  	    		$image = $this->request->files('image');
  	    		if(!empty($image['name']) && in_array(strtolower(pathinfo($image['name'], PATHINFO_EXTENSION)), $this->allowed_image_extentions))
  	    		{
  	    			$this->categories->delete_image($category->id);
  	    			move_uploaded_file($image['tmp_name'], $this->root_dir.$this->config->categories_images_dir.$image['name']);
  	    			$this->categories->update_category($category->id, array('image'=>$image['name']));
  	    		}
  	    		$category = $this->categories->get_category(intval($category->id));
			}

			if(is_array($this->request->post('related_products')))
			{
				foreach($this->request->post('related_products') as $p)
				{
					$rp[$p] = new stdClass;
					$rp[$p]->product_id = $product->id;
					$rp[$p]->related_id = $p;
				}
				$related_products = $rp;
			}

			$rp = array();
			// Связанные товары
    		$query = $this->db->placehold('DELETE FROM __c_related_products WHERE category_id=?', $category->id);
    		$this->db->query($query);
 		    if(is_array($related_products))
  		    {
  		    	$pos = 0;
  		    	foreach($related_products  as $i=>$related_product)
 	    			$this->categories->add_related_product($category->id, $related_product->related_id, $pos++);
  	    	}
			if(is_array($this->request->post('pin_products')))
			{
				foreach($this->request->post('pin_products') as $p)
				{
					$rp[$p] = new stdClass;
					$rp[$p]->product_id = $product->id;
					$rp[$p]->related_id = $p;
				}
				$pin_products = $rp;
			}

			// Связанные товары
    		$query = $this->db->placehold('DELETE FROM __c_pin_products WHERE category_id=?', $category->id);
    		$this->db->query($query);
 		    if(is_array($pin_products))
  		    {
  		    	$pos = 0;
  		    	foreach($pin_products  as $i=>$pin_product)
 	    			$this->categories->add_pin_product($category->id, $pin_product->related_id, $pos++);
  	    	}
		}
		else
		{
			$category->id = $this->request->get('id', 'integer');
			$category = $this->categories->get_category($category->id);

			// Связанные товары
			$related_products = $this->categories->get_related_products(array('category_id'=>$category->id));
			// Прибитые товары
			$pin_products = $this->categories->get_pin_products(array('category_id'=>$category->id));
		}
		
		if(!empty($related_products))
		{
			foreach($related_products as &$r_p)
				$r_products[$r_p->related_id] = &$r_p;
			$temp_products = $this->products->get_products(array('id'=>array_keys($r_products)));
			foreach($temp_products as $temp_product)
				$r_products[$temp_product->id] = $temp_product;
		
			$related_products_images = $this->products->get_images(array('product_id'=>array_keys($r_products)));
			foreach($related_products_images as $image)
			{
				$r_products[$image->product_id]->images[] = $image;
			}
		}

		if(!empty($pin_products))
		{
			foreach($pin_products as &$r_p)
				$r_products[$r_p->related_id] = &$r_p;
			$temp_products = $this->products->get_products(array('id'=>array_keys($r_products)));
			foreach($temp_products as $temp_product)
				$r_products[$temp_product->id] = $temp_product;
		
			$pin_products_images = $this->products->get_images(array('product_id'=>array_keys($r_products)));
			foreach($pin_products_images as $image)
			{
				$r_products[$image->product_id]->images[] = $image;
			}
		}

		$categories = $this->categories->get_categories_tree();

		$this->design->assign('related_products', $related_products);		
		$this->design->assign('pin_products', $pin_products);		
		$this->design->assign('accessories_category_id', $this->settings->accessories_category);
		$this->design->assign('category', $category);
		$this->design->assign('categories', $categories);
		return  $this->design->fetch('category.tpl');
	}
}