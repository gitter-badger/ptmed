<?PHP

/**
 * Simpla CMS
 *
 * @copyright 	2011 Denis Pikusov
 * @link 		http://simplacms.ru
 * @author 		Denis Pikusov
 *
 * Этот класс использует шаблон products.tpl
 *
 */
 
require_once('View.php');

class PriceView extends View
{
 	/**
	 *
	 * Отображение списка товаров
	 *
	 */	
	function fetch()
	{
		// GET-Параметры
		$category_url = $this->request->get('category_url', 'string');
		$brand_url    = $this->request->get('brand', 'string');
		
		$filter = array();
		$filter['visible'] = 1;	
		//не вспомогательное оборудование
		$filter['featured'] = 0;
		//не дополнительная опция
		$filter['dop'] = 0;

		// Если задан бренд, выберем его из базы
		if (!empty($brand_url))
		{
			$brand = $this->brands->get_brand((string)$brand_url);
			if (empty($brand))
				return false;
			$this->design->assign('brand', $brand);
			$filter['brand_id'] = $brand->id;
		}
		
		// Выберем текущую категорию
		if (!empty($category_url))
		{
			$category = $this->categories->get_category((string)$category_url);
			if (empty($category) || (!$category->visible && empty($_SESSION['admin'])))
				return false;
			$this->design->assign('category', $category);
			$filter['category_id'] = $category->children;
		}

		// Если задано ключевое слово
		$keyword = $this->request->get('keyword');
		if (!empty($keyword))
		{
			$this->design->assign('keyword', $keyword);
			$filter['keyword'] = $keyword;
		}

		// Сортировка товаров, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
		if($sort = $this->request->get('sort', 'string'))
			$_SESSION['sort'] = $sort;		
		if (!empty($_SESSION['sort']))
			$filter['sort'] = $_SESSION['sort'];			
		else
			$filter['sort'] = 'position';			
		$this->design->assign('sort', $filter['sort']);
		
		// Свойства товаров
		if(!empty($category))
		{
			$features = array();
			foreach($this->features->get_features(array('category_id'=>$category->id, 'in_filter'=>1)) as $feature)
			{ 
				$features[$feature->id] = $feature;
				if(($val = strval($this->request->get($feature->id)))!='')
					$filter['features'][$feature->id] = $val;	
			}
			
			$options_filter['visible'] = 1;
			
			$features_ids = array_keys($features);
			if(!empty($features_ids))
				$options_filter['feature_id'] = $features_ids;
			$options_filter['category_id'] = $category->children;
			if(isset($filter['features']))
				$options_filter['features'] = $filter['features'];
			if(!empty($brand))
				$options_filter['brand_id'] = $brand->id;
			
			$options = $this->features->get_options($options_filter);

			foreach($options as $option)
			{
				if(isset($features[$option->feature_id]))
					$features[$option->feature_id]->options[] = $option;
			}
			
			foreach($features as $i=>&$feature)
			{ 
				if(empty($feature->options))
					unset($features[$i]);
			}

			$this->design->assign('features', $features);
 		}

		// Постраничная навигация
		$items_per_page = $this->settings->products_num;		
		// Текущая страница в постраничном выводе
		$current_page = $this->request->get('page', 'int');	
		// Если не задана, то равна 1
		$current_page = max(1, $current_page);
		$this->design->assign('current_page_num', $current_page);
		// Вычисляем количество страниц
		$products_count = $this->products->count_products($filter);
		
		// Показать все страницы сразу
		if($this->request->get('page') == 'all')
			$items_per_page = $products_count;	
		
		$pages_num = ceil($products_count/$items_per_page);
		$this->design->assign('total_pages_num', $pages_num);
		$this->design->assign('total_products_num', $products_count);

		$filter['page'] = $current_page;
		$filter['limit'] = $items_per_page;
		$filter['sort'] = 'name';
		
		///////////////////////////////////////////////
		// Постраничная навигация END
		///////////////////////////////////////////////
		

		$discount = 0;
		if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id'])))
			$discount = $user->discount;
			
		// Товары 
		$products = array();
		foreach($this->products->get_products($filter) as $p)
		{
			$related_ids = array();
			$related_products = array();
			foreach($this->products->get_related_products($p->id) as $r)
			{
				$related_ids[] = $r->related_id;
				$related_products[$r->related_id] = null;
			}

			if(!empty($related_ids))
			{
				//foreach($this->products->get_products(array('id'=>$related_ids, 'in_stock'=>1, 'visible'=>1)) as $pr)
				foreach($this->products->get_products(array('id'=>$related_ids)) as $pr)
					$related_products[$pr->id] = $pr;
			
				$related_products_images = $this->products->get_images(array('product_id'=>array_keys($related_products)));
				foreach($related_products_images as $related_product_image)
					if(isset($related_products[$related_product_image->product_id]))
						$related_products[$related_product_image->product_id]->images[] = $related_product_image;
				$related_products_variants = $this->variants->get_variants(array('product_id'=>array_keys($related_products), 'in_stock'=>1));
				foreach($related_products_variants as $related_product_variant)
				{
					if(isset($related_products[$related_product_variant->product_id]))
					{
						$related_products[$related_product_variant->product_id]->variants[] = $related_product_variant;
					}
				}
				foreach($related_products as $id=>$r)
				{
					if(is_object($r))
					{
						$r->image = &$r->images[0];
						$r->variant = &$r->variants[0];
					}
					else
					{
						unset($related_products[$id]);
					}
				}
				$p->related_products = $related_products;
			}

			$products[$p->id] = $p;

		}

		// Если искали товар и найден ровно один - перенаправляем на него
		if(!empty($keyword) && $products_count == 1)
			header('Location: '.$this->config->root_url.'/products/'.$p->url);
		
		if(!empty($products))
		{
			$products_ids = array_keys($products);
			foreach($products as &$product)
			{
				$product->variants = array();
				$product->images = array();
				$product->properties = array();
			}
	
			$variants = $this->variants->get_variants(array('product_id'=>$products_ids, 'in_stock'=>true));
			
			foreach($variants as &$variant)
			{
				//$variant->price *= (100-$discount)/100;
				$products[$variant->product_id]->variants[] = $variant;
			}
	
			$images = $this->products->get_images(array('product_id'=>$products_ids));
			foreach($images as $image)
				$products[$image->product_id]->images[] = $image;

			foreach($products as &$product)
			{
				if(isset($product->variants[0]))
					$product->variant = $product->variants[0];
				if(isset($product->images[0]))
					$product->image = $product->images[0];
				$rps = $this->products->get_related_products($product->id, array('featured'=>1)); 
				$product->fets = $this->add_variants_to_related_products($rps); 
				$rps = $this->products->get_related_products($product->id, array('dop'=>1));
				$product->dops = $this->add_variants_to_related_products($rps); 
			}
				
	
			/*
			$properties = $this->features->get_options(array('product_id'=>$products_ids));
			foreach($properties as $property)
				$products[$property->product_id]->options[] = $property;
			*/
	
			//$this->design->assign('products', $products);
 		}
		
		// Выбираем бренды, они нужны нам в шаблоне	
		if(!empty($category))
		{
			$brands = $this->brands->get_brands(array('category_id'=>$category->children, 'visible'=>1));
			$category->brands = $brands;		
		}
		
		// Устанавливаем мета-теги в зависимости от запроса
		if($this->page)
		{
			$this->design->assign('meta_title', $this->page->meta_title);
			$this->design->assign('meta_keywords', $this->page->meta_keywords);
			$this->design->assign('meta_description', $this->page->meta_description);
		}
		elseif(isset($category))
		{
			$this->design->assign('meta_title', $category->meta_title);
			$this->design->assign('meta_keywords', $category->meta_keywords);
			$this->design->assign('meta_description', $category->meta_description);
		}
		elseif(isset($brand))
		{
			$this->design->assign('meta_title', $brand->meta_title);
			$this->design->assign('meta_keywords', $brand->meta_keywords);
			$this->design->assign('meta_description', $brand->meta_description);
		}
		elseif(isset($keyword))
		{
			$this->design->assign('meta_title', $keyword);
		}
		
		
		//Доп. опции и вспомогательное оборудование
		//Соберем все различные связаные товары для всех товаров
		//два раза - для доп. опций и для вспомогательного оборудования	

		//массив id товаров
		$products_ids = array_keys($products);

		//$rps = $this->products->get_related_products($products_ids, array('dop'=>1));
		//$dops = $this->add_variants_to_related_products($rps);
		//$this->design->assign('dops', $dops);

		//$rps = $this->products->get_related_products($products_ids, array('featured'=>1));
		//$fets = $this->add_variants_to_related_products($rps);
		//$this->design->assign('fets', $fets);

		$rps = $this->products->get_related_products($products_ids, array('dop'=>1));
		$unique_prs = array();
		foreach ($rps as $rp) 
			$unique_prs[$rp->related_id] = $rp; 
		$dops = $this->add_variants_to_related_products($unique_prs);
		$this->design->assign('dops', $dops);

		//Вспомогательное оборудование возьмем из категории
		$rps = $this->products->get_related_products($products_ids, array('featured'=>1));
		$c_rps = $this->categories->get_related_products($category->id, array('featured'=>1));
		foreach ($c_rps as $c_rp) {
			$rp = new StdClass;
			$rp->product_id = $products_ids[0];
			$rp->related_id = $c_rp->related_id;
			$rp->position = $c_rp->position;
			$rp->featured = 1;
			$rps[] = $rp;
		}
		$unique_prs = array();
		foreach ($rps as $rp) 
			$unique_prs[$rp->related_id] = $rp; 
		$fets = $this->add_variants_to_related_products($unique_prs);
		$this->design->assign('fets', $fets);

		$cats = array();
		foreach ($category->children as $cid)
		{
			$cat = $this->categories->get_category($cid);
			$filter['category_id'] = $cid;
			$ps = array();
			foreach($this->products->get_products($filter) as $p)
				$ps[$p->id] = $products[$p->id];
			$cat->products = $ps;
			$cats[] = $cat;
		}
		//	$
		//$this->design->assign('products', $products);
		$this->design->assign('cats', $cats);


		$this->body = $this->design->fetch('price.tpl');
		return $this->body;
	}
	
	private function add_variants_to_related_products($rps)
	{
		foreach ($rps as $rp) 
		{
			$p = $this->products->get_product((int)$rp->related_id);
			$variants = $this->variants->get_variants(array('product_id'=>$p->id));
			
			foreach($variants as &$variant)
				$p->variants[] = $variant;

			$related_products[$rp->position] = $p;
		}

		return $related_products;
	}
}
