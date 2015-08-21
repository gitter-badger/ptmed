<?php
	require_once('../../api/Simpla.php');
	$simpla = new Simpla();
	$limit = 100;
	
	$keyword = $simpla->request->get('query', 'string');
	$category_id = $simpla->request->get('category_id_filter', 'integer');
	//фильтр по товару используется при выборе вспомогательного оборудования для товара
	//по товару определяется категория, из которой берется список вспомогательногооборудования
	$product_id = $simpla->request->get('product_id_filter', 'integer');
	//фильтр по вспомогательному оборудованию
	$featured = $simpla->request->get('is_featured_filter', 'integer');
	//фильтр по доп. опциям
	$dop = $simpla->request->get('is_dop_filter', 'integer');

	$keywords = explode(' ', $keyword);
	$keyword_sql = '';
	foreach($keywords as $keyword)
	{
		$kw = $simpla->db->escape(trim($keyword));
		$keyword_sql .= $simpla->db->placehold("AND (p.name LIKE '%$kw%' OR p.meta_keywords LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%'))");
	}

	$category_id_filter = '';
	if($category_id)
	{
		$category_id_filter = $simpla->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$category_id);
	}
	
	$is_featured_filter = '';
	$cateory_vspom_filter = '';
	if($featured)
	{
		$is_featured_filter = $simpla->db->placehold('AND p.featured=?', 1);
		if($product_id)
		{
			$cats = $simpla->categories->get_product_categories($product_id);
			if($cats)
			{
				$category_id = $cats[0]->category_id;
				$cateory_vspom_filter = $simpla->db->placehold('AND p.id in (SELECT related_id FROM __c_related_products WHERE category_id = ?)', $category_id);
			}
		}
	}

	$is_dop_filter = '';
	if($dop)
		$is_dop_filter = $simpla->db->placehold('AND p.dop=?', 1);

	$simpla->db->query('SELECT p.id, p.name, i.filename as image, p.dop, p.featured FROM __products p '.$category_id_filter. '
	                    LEFT JOIN __images i ON i.product_id=p.id AND i.position=(SELECT MIN(position) FROM __images WHERE product_id=p.id LIMIT 1)
	                    WHERE 1 '.$cateory_vspom_filter.$keyword_sql.$is_featured_filter.$is_dop_filter.' ORDER BY p.name LIMIT ?', $limit);
	$products = $simpla->db->results();

	$suggestions = array();
	foreach($products as $product)
	{
		if(!empty($product->image))
			$product->image = $simpla->design->resize_modifier($product->image, 35, 35);
		
		$suggestion = new stdClass();
		$suggestion->value = $product->name;
		$suggestion->data = $product;
		$suggestions[] = $suggestion;
	}
	
	$res = new stdClass;
	$res->query = $keyword;
	$res->suggestions = $suggestions;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($res);
