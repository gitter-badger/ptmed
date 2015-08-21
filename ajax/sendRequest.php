<?php
	require_once('../api/Simpla.php');
	$simpla = new Simpla();
	$name = $simpla->request->post('name', 'string');
	$email = $simpla->request->post('email', 'string');
	$phone = $simpla->request->post('phone', 'string');
	$_options = $simpla->request->post('options');
	if( $_options === '' )
		$options = array();
	else
		$options = explode(',', $_options);
	$variant_id = $simpla->request->post('variant', 'integer');
	$product_id = $simpla->request->post('product', 'integer');
	
	$order = new stdClass;
    //$order->delivery_id = $this->request->post('delivery_id', 'integer');
   	$order->name        = $name;
   	$order->email       = $email;
   	//$order->address     = $this->request->post('address');
   	$order->phone       = $phone;
   	//$order->comment     = $this->request->post('comment');
   	$order->ip      	= $_SERVER['REMOTE_ADDR'];

	$order->id = $simpla->orders->add_order($order);
	$simpla->orders->add_purchase(array('order_id'=>$order->id, 'variant_id'=>intval($variant_id), 'amount'=>1));
	if($options)
		foreach($options as $variant_id)
			$simpla->orders->add_purchase(array('order_id'=>$order->id, 'variant_id'=>intval($variant_id), 'amount'=>1));

	$simpla->notify->email_order_user($order->id);
	$simpla->notify->email_order_admin($order->id);
	    	

	$res = new stdClass;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($res);
