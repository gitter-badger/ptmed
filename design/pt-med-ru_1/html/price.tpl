<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
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

{if $cats} 
{foreach $cats as $cat}
{if $cat->products}
<h3>{$cat->name|escape}</h3>
<div id="product-list">
<div class="panel list-group">
{foreach $cat->products as $product}
{foreach $product->variants as $v}
 <div class="list-group-item">
     <a href="products/{$product->url}">&nbsp;&nbsp;
         <img src="{$product->image->filename|resize:30:30}" class="img-thumbnail"/>
     </a>
     <span class="wpap">
         <a class="name-p" href="/products/{$product->url}">  {$product->name|escape}
             <a class="dopprod" href="#product-{$v->id}" data-toggle="collapse" data-parent="#product-list" title="Дополнительные опции">
                 <span class="glyphicon glyphicon-plus-sign pull-left"></span>
             </a>
         </a>
     </span>
     <span class="pull-right">{$v->price|convert} {$currency->sign|escape}&nbsp;&nbsp;-&nbsp;&nbsp;{$v->price|convert:EUR} €</span>
 </div>

 <div id="product-{$v->id}" class="sublinks collapse">
  {if $product->dops} 
  {foreach $product->dops as $related} 
  {foreach $related->variants as $v}
  <a class="list-group-item small"><span class="glyphicon glyphicon-chevron-right"></span> {$related->name|escape}&nbsp;{if $v->name}{$v->name}{/if}<span class="pull-right">{$v->price|convert:EUR} €</span><span class="pull-right">{if $v->compare_price > 0} {$v->compare_price|convert} {/if}{$v->price|convert} {$currency->sign|escape}&nbsp;&nbsp;-&nbsp;&nbsp;</span></a>
  {/foreach}  
  {/foreach}  
  {/if}
</div>
{/foreach}
{/foreach}
</div>
</div>
{/if}
{/foreach}

{if !$category->group_options_in_price}
{if $fets}
<h3>Вспомогательное оборудование</h3>
<div id="product-list">
<div class="panel list-group">
{foreach $fets as $related} 
{foreach $related->variants as $v}
 <div class="list-group-item"><a href="products/{$related->url}">{$related->name|escape} {$v->name|escape} </a><span class="pull-right">{$v->price|convert} {$currency->sign|escape}&nbsp;&nbsp;-&nbsp;&nbsp;{$v->price|convert:EUR} €</span></div>
{/foreach}  
{/foreach}  
</div>
</div>
{/if}
{/if}

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