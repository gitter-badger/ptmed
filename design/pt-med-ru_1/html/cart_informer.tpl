{* Информера корзины (отдаётся аяксом) *}
{if $cart->total_products>0}
        <span><i class="fa fa-shopping-cart"></i></span>
	<div>В <a href="./cart/">корзине</a>
        {$cart->total_products} {$cart->total_products|plural:'товар':'товаров':'товара'}<br/>
	на {$cart->total_price|convert} {$currency->sign|escape}
{else}
	Корзина пуста
{/if}
</div>