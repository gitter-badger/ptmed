{* Список товаров *}

{$meta_title = "Прайс лист - {$category->name|escape}" scope=parent}

{* Канонический адрес страницы *}
{if $category && $brand}
{$canonical="/catalog/{$category->url}/{$brand->url}" scope=parent}
{elseif $category}
{$canonical="/catalog/{$category->url}" scope=parent}
{elseif $brand}
{$canonical="/brands/{$brand->url}" scope=parent}
{elseif $keyword}
{$canonical="/products?keyword={$keyword|escape}" scope=parent}
{else}
{$canonical="/products" scope=parent}
{/if}

{* Хлебные крошки *}
<div id="path">
	<a href="/">Главная</a>
	{if $category}
	{foreach from=$category->path item=cat}
	&#187; <a href="catalog/{$cat->url}">{$cat->name|escape}</a>
	{/foreach}  
	{if $brand}
	&#187; <a href="catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a>
	{/if}
	{elseif $brand}
	&#187; <a href="brands/{$brand->url}">{$brand->name|escape}</a>
	{elseif $keyword}
	&#187; Поиск
	{/if}
 	&#187; Прайс-лист
</div>

{* Заголовок страницы *}
{if $keyword}
<h1>Поиск {$keyword|escape}</h1>
{elseif $page}
<h1>{$page->name|escape}</h1>
{else}
<h1>{$category->name|escape} {$brand->name|escape} {$keyword|escape} - прайс лист</h1>
{/if}


{if $products} 
<div class="price-block">    
{foreach $products as $product}
{if $product->variants|@count == 1}
<div class="price-list-product-line">
  {foreach $product->variants as $v}
  <div class="price-list-product-line-image">
    <a href="products/{$product->url}"><img src="{$product->image->filename|resize:60:60}"/></a>
  </div>
  <div class="price-list-product-line-title">
    <a href="products/{$product->url}"><b>{$product->name|escape}</b></a>
  </div>
  <div class="price-list-product-line-price">
    <b>{$v->price|convert} {$currency->sign|escape}</b>
  </div>
  <div class="price-list-product-line-price-eur">
    <b>{$v->price|convert:EUR} €</b>
  </div>
</div>
{/foreach}
{else}
<div class="price-list-product-variants-line">
  <div class="price-list-product-line-image">
    <a href="products/{$product->url}"><img src="{$product->image->filename|resize:60:60}"/></a>
  </div>
  <div class="price-list-product-line-title">
      <a href="products/{$product->url}"></img><b>{$product->name|escape}</b></a>
  </div>
{foreach $product->variants as $v}
<div class="price-list-variant-line">
  <div class="price-list-variant-line-title">
    <a href="products/{$product->url}">{$v->name}</a>
  </div>
  <div class="price-list-variant-line-price">
      <b>{$v->price|convert} {$currency->sign|escape}</b>
  </div>
  <div class="price-list-variant-line-price-eur">
      <b>{$v->price|convert:EUR} €</b>
  </div>
</div>
 {/foreach}
</div>
 {/if}
<div class="price-block">    
{if $product->fets} 
<p>Вспомогательное оборудование</p>
{foreach $product->fets as $related} 
  {include file='related_view_list.tpl'} 
{/foreach}  
{else}
<p>Для этого товара не предусмотрено вспомогательное оборудование</p>
{/if}
</div>

<div class="price-block">    
{if $product->dops} 
<p>Дополнительные опции</p>
{foreach $product->dops as $related} 
  {include file='related_view_list.tpl'} 
{/foreach}  
{else}
<p>Для этого товара не предусмотрены дополнительные опции</p>
{/if}
</div>
{/foreach}
</div>

{include file='pagination.tpl'}	

{else}

{/if}


{* Описание страницы (если задана) *}
{$page->body}

{if $current_page_num==1}
{* Описание категории *}
{$category->description}
{/if}

{if $current_page_num==1}
{* Описание бренда *}
{$brand->description}
{/if}