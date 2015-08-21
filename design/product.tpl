{* Страница товара *}

{* Канонический адрес страницы *}
{$canonical="/products/{$product->url}" scope=parent}


<div id="path">
	<a href="./">Главная</a>
	{foreach from=$category->path item=cat}
	&#187; <a href="catalog/{$cat->url}">{$cat->name|escape}</a>
	{/foreach}
	{if $brand}
	&#187; <a href="catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a>
	{/if}
	&#187;  {$product->name|escape}                
</div>

<h1>{$product->name|escape}</h1>

<div class="product">

{* Большое фото *}
    {if $product->image}
	<div class="image">
            <a href="{$product->image->filename|resize:1024:768:w}" class="zoom" rel="group"><img src="{$product->image->filename|resize:480:360}" alt="{$product->product->name|escape}" /></a>
	</div>
    {/if}

{* Дополнительные фото товара *}    
    {if $product->images|count>1}
    <div class="images">
            {foreach $product->images|cut as $i=>$image}
                    <a href="{$image->filename|resize:1024:768:w}" class="zoom" rel="group"><img src="{$image->filename|resize:110:110}" alt="{$product->name|escape}" /></a>
            {/foreach}
    </div>
    {/if}

{* Ссылка на конфигуратор *}
<div class="price-sheet">    
    <a href="products/{$product->url}#konfigarator">Перейти к конфигуратору</a>
    <a href="price/{$category->url}">Сравнить цены</a>
</div>  
    
{* Применение и описание товара *}    
    <div class="description">
    {$product->body}
    </div>
    
{* Технические характеристики *}
    {if $product->features}
        <div class="table-block">
        <h2>Технические характеристики</h2>
	<table class="features">
	{foreach $product->features as $f}
	<tr>
		<td>{$f->name}</td>
		<td>{$f->value}</td>
	</tr>
	{/foreach}
	</table>
        </div>
    {/if}  
    
{* Монтажные схемы, мертификаты и РУ (Используем краткое описание товара) *} 
    {$product->annotation}

{* Конфигуратор *}
<a id="konfigarator"></a>
<h2>Конфигуратор</h2>
<div class="configurator">
    <form class="variants" action="/cart">
{if $product->variants|count > 0}
        <table>
            {foreach $product->variants as $v}
            <tr>
                <td>
                    <input id="product_{$v->id}" name="variant_{$v->id}" price_eur='{$v->price|convert:EUR}' price='{$v->price}' value="{$v->id}" type="radio" class="variant_radiobutton" {if $product->variant->id==$v->id}checked{/if}/>
                </td>
                <td>
                    <img src="{$product->image->filename|resize:120:120}" alt="{$product->product->name|escape}" />
                </td>
                <td>
                    {$product->name|escape} {*(базовая комплектация)*}
                    {if $v->name}<label class="variant_name" for="product_{$v->id}">{$v->name}</label>{/if}
                </td>
                <td>
                    {if $v->compare_price > 0} 
                        {$v->compare_price|convert} 
                    {/if}
                    {$v->price|convert} {$currency->sign|escape}
                </td>
                <td>
                    {$v->price|convert:EUR} {$eur->sign|escape}
               </td> 
            </tr>
            {/foreach}
        </table>
    {else}
            <p>Нет в наличии</p>
    {/if}
    
{* Связанные товары *}
{if $related_products}
<h3>Дополнительные опции</h3>
<table>
    {foreach $related_products as $related_product}
        <tr>
            <td>
            {if $related_product->variants|count > 0}
		{foreach $related_product->variants as $v}
                    <input id="{$v->id}" name="config_{$v->id}" price='{$v->price}' price_eur='{$v->price|convert:EUR}' value="{$v->id}" type="checkbox" class="variant_radiobutton"/>
		{/foreach}
            {else}
		Нет в наличии
            {/if}            
            </td> 
            
		<td>
        {if $related_product->image}
                    <a href="products/{$related_product->url}">
                        <img src="{$related_product->image->filename|resize:50:50}" alt="{$related_product->name|escape}"/>
                    </a>
		 {/if}
        </td>    
            <td>
                <a data-product="{$related_product->id}" href="products/{$related_product->url}">
                    {$related_product->name|escape}
                </a>
            </td>
                
            <td>
            {if $related_product->variants|count > 0}
                {foreach $related_product->variants as $v}
                    {if $v->compare_price > 0}
                        {$v->compare_price|convert}
                    {/if}
                    {$v->price|convert} {$currency->sign|escape}
                {/foreach}
            {else}
                Нет в наличии
            {/if}        
            </td>
            <td>
            {$v->price|convert:EUR} {$eur->sign|escape}
           </td> 
	</tr>
    {/foreach}
 
 <tr>
<td colspan="3" class="itogo">Итоговая сумма:</td>
<td class="rub"><label id='total'>0</label> {$currency->sign|escape}</td>  
<td class="euro"><label id='total_eur'>0</label>{$eur->sign|escape}</td>  
 </tr> 
</table>
{/if} 
<p><div class="request-me"><a href="#request">Отправить запрос</a></div></p>
</form>
</div>    
</div>

{literal}
<script>
$(function(){
    calc();
    $("input[name^=config_]").change(function(){
        calc();
    });
    $("input[name^=variant_]").change(function(){
        calc();
    });
});

function calc(){
    var total = 0;
    var total_eur = 0;
    $("input[name^=variant_]").each(
        function(indx){
            var checked = $(this).attr('checked');
            if(checked){
                total += parseInt($(this).attr('price'));
                total_eur += parseInt($(this).attr('price_eur').replace(' ',''));
                $('input#variant').val($(this).val());
            }
        }
    );
    
    var options = '';
    $("input[name^=config_]").each(
        function(indx){
            var checked = $(this).attr('checked');
            if(checked){
                total += parseInt($(this).attr('price'));
                total_eur += parseInt($(this).attr('price_eur').replace(' ',''));
                if(options)
                    options += ','+$(this).val();
                else
                    options = $(this).val();
            }
        }
    );
    $('input#options').val(options);
    $("label#total").html(total);
    $("label#total_eur").html(total_eur);
}
</script>
{/literal}

<script type="text/javascript" src="js/fancybox/jquery.fancybox.pack.js"></script>
<link rel="stylesheet" href="js/fancybox/jquery.fancybox.css" type="text/css" media="screen" />

<div style="display:none; width: ">
    <div id="request">
        <h2 style="/*#a2062d;*/ font-size: 21px;">Заказ обратного звонка</h2>
        <form id="mail_form" class="form feedback_form" method="post" style="width: 82%;">
            <p class="reset-margin-padding callbacklines"></p>
            <label class="labe_txt">Имя</label>
             <div style="clear:both"></div>
             <input type="text" name="name" value="" data-format=".+" data-notice="Введите имя" id="nickname_field" value="" class="input-text" style=""/><br/>
             
             <label class="labe_txt">Номер телефона</label>
             <div style="clear:both"></div>
             <input data-format=".+" data-notice="Введите номер телефона" value="" name="phone" maxlength="255" type="text"  class="input-text"/>
             <div style="clear:both"></div>  

             <label class="labe_txt">Email</label>
             <div style="clear:both"></div>
             <input data-format=".+" data-notice="Введите email" value="" name="email" maxlength="255" type="text"  class="input-text"/>
             <div style="clear:both"></div>  
            
            <input class="button_description button" type="submit" name="callback" value="Заказать"/>
            <input type="hidden" id="options" name="options" value=""/>
            <input type="hidden" id="variant" name="variant" value=""/>
            <input type="hidden" id="product" name="product" value="{$product->id}"/>
        </form>
    </div>
</div>
<script>
    $(function() {
        $('.request-me a').fancybox();
        $('input#request_button').fancybox();
    });
</script>