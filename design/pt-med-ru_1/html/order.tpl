{* Страница заказа *}

{$meta_title = "Ваш заказ №`$order->id`" scope=parent}

<div class="purchases cart">

<div class="purchases-right-block">

<h1>Ваш заказ №{$order->id}</h1>

{* Детали заказа *}
<h2>Детали заказа</h2>
<table class="order_info">
	<tr>
		<td>
			Дата заказа
		</td>
		<td>
			{$order->date|date} в
			{$order->date|time}
		</td>
	</tr>
	{if $order->name}
	<tr>
		<td>
			Имя
		</td>
		<td>
			{$order->name|escape}
		</td>
	</tr>
	{/if}
	{if $order->email}
	<tr>
		<td>
			Email
		</td>
		<td>
			{$order->email|escape}
		</td>
	</tr>
	{/if}
	{if $order->phone}
	<tr>
		<td>
			Телефон
		</td>
		<td>
			{$order->phone|escape}
		</td>
	</tr>
	{/if}
	{if $order->address}
	<tr>
		<td>
			Адрес доставки
		</td>
		<td>
			{$order->address|escape}
		</td>
	</tr>
	{/if}
	{if $order->comment}
	<tr>
		<td>
			Комментарий
		</td>
		<td>
			{$order->comment|escape|nl2br}
		</td>
	</tr>
	{/if}
</table>

</div>

<div class="purchases-left-block">
	{* Список покупок *}

	<h2>Cтатус заказа ({if $order->status == 0}принят{/if}{if $order->status == 1}в обработке{elseif $order->status == 2}выполнен{/if}{if $order->paid == 1}, оплачен{else}{/if})</h2>

	<table id="purchases">

		{foreach $purchases as $purchase}
			<tr>
				{* Изображение товара *}
				<td class="image">
					{$image = $purchase->product->images|first}
					{if $image}
						<a href="products/{$purchase->product->url}"><img
									src="{$image->filename|resize:50:50}" alt="{$product->name|escape}"></a>
					{/if}
				</td>

				{* Название товара *}
				<td class="name">
					<a href="products/{$purchase->product->url}">{$purchase->product->name|escape}</a>
				</td>

				{* Количество *}
				<td class="amount">
					&times; {$purchase->amount}&nbsp;{$settings->units}
				</td>

				{* Цена *}
				<td class="price">
					<div class="p_ru">{($purchase->variant->price*$purchase->amount)|convert}&nbsp;{$currency->sign}</div>
					{*<div class="p_eur">{($purchase->variant->price*$purchase->amount)|convert:EUR}&nbsp;{$eur->sign|escape}</div>*}
				</td>

			</tr>
		{/foreach}
		{if $user->discount}
			<tr>
				<th class="image"></th>
				<th class="name">скидка</th>
				<th class="price"></th>
				<th class="amount"></th>
				<th class="price">
					{$user->discount}&nbsp;%
				</th>
				<th class="remove"></th>
			</tr>
		{/if}

	</table>
	<div class="purchases-total-block">
		<div class="c30"> &nbsp; </div>
		<div class="c30"> &nbsp; </div>
		<div class="c40 text-align-right">Итого:&nbsp;{$order->total_price|convert}&nbsp;{$currency->sign}</div>
	</div>
</div>

<div class="deliveries-payment blc-2">
{if !$order->paid}
{* Выбор способа оплаты *}
{if $payment_methods && !$payment_method && $order->total_price>0}
<form method="post">
<h2>Выберите способ оплаты</h2>
<ul id="deliveries">
    {foreach $payment_methods as $payment_method}
    	<li>
    		<div class="checkbox">
    			<input type=radio name=payment_method_id value='{$payment_method->id}' {if $payment_method@first}checked{/if} id=payment_{$payment_method->id}>
    		</div>			
			<h3><label for=payment_{$payment_method->id}>	{$payment_method->name}, к оплате {$order->total_price|convert:$payment_method->currency_id}&nbsp;{$all_currencies[$payment_method->currency_id]->sign}</label></h3>
			<div class="description">
			{$payment_method->description}
			</div>
    	</li>
    {/foreach}
</ul>
<input type='submit' class="btn-buy" value='Закончить заказ'>
</form>

{* Выбраный способ оплаты *}
{elseif $payment_method}
<h2>Способ оплаты &mdash; {$payment_method->name}
<form method=post><input class="btn-buy" type=submit name='reset_payment_method' value='Выбрать другой способ оплаты'></form>
</h2>
<p>
{$payment_method->description}
</p>
<h2>
К оплате {$order->total_price|convert:$payment_method->currency_id}&nbsp;{$all_currencies[$payment_method->currency_id]->sign}
</h2>

{* Форма оплаты, генерируется модулем оплаты *}
{checkout_form order_id=$order->id module=$payment_method->module}
{/if}
</div>

{/if}

</div>

 