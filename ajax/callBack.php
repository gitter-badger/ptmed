<?php
	require_once('../api/Simpla.php');
	$simpla = new Simpla();
	$name = $simpla->request->post('cb_name', 'string');
	$phone = $simpla->request->post('cb_phone', 'string');
	$url = $simpla->request->post('cb_url', 'string');
	
	$feedback = new stdClass;
   	$feedback->name        = $name;
   	$feedback->email       = $phone;
   	$feedback->ip    	   = $_SERVER['REMOTE_ADDR'];
   	$feedback->message     = "Заказ обратного звонка со страницы " + string($url);	    	
   	$simpla->feedbacks->add_feedback($feedback);

	$res = new stdClass;
	header("Content-type: application/json; charset=UTF-8");
	header("Cache-Control: must-revalidate");
	header("Pragma: no-cache");
	header("Expires: -1");		
	print json_encode($res);