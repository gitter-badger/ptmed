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
<table class="table table-striped">    
{foreach $cats as $cat}
{if $cat->products}
<thead>
<th colspan="4"><h3>{$cat->name}</h3></th>
</thead>
{foreach $cat->products as $product}
{if $product->variants|@count == 1}
<thead>
{foreach $product->variants as $v}
  <th><a href="products/{$product->url}"><img src="{$product->image->filename|resize:60:60}" class="img-thumbnail"/></a></th>
  <th><a href="products/{$product->url}">{$product->name|escape}</a></th>
  <th>{$v->price|convert} {$currency->sign|escape}</th>
  <th>{$v->price|convert:EUR} €<th>
{/foreach}
</thead>
{else}
<thead>
  <th><a href="products/{$product->url}"><img src="{$product->image->filename|resize:60:60}" class="img-thumbnail"/></a></th>
  <th colspan="3"><a href="products/{$product->url}"></img>{$product->name|escape}</a></th>
  {foreach $product->variants as $v}
  <thead>
  <th></th>
  <th><a href="products/{$product->url}">{$v->name}</a></th>
  <th>{$v->price|convert} {$currency->sign|escape}</th>
  <th>{$v->price|convert:EUR} €</th>
</thead>
{/foreach}
{/if}
{if $product->fets && $category->group_options_in_price}
<tr> 
<td></td>
<td colspan="3">Вспомогательное оборудование</td>
</tr>
{foreach $product->fets as $related} 
  {include file='related_view_list.tpl'} 
{/foreach}  
{/if}

{if $product->dops} 
<tr> 
<td></td>
<td colspan="3">Дополнительные опции<a href="#toggleSample" data-toggle="collapse" data-target="#toggleSample" value="Элемент управления"></td>
</tr>
/<tr><td colspan="3">
<table id="toggleSample" class="collapse out">
{foreach $product->dops as $related} 
{include file='related_view_list.tpl'} 
{/foreach}  
</table>
</td></tr>
{/if}

{/foreach}
{/if}
{/foreach}  

{if !$category->group_options_in_price}
{if $fets}
<thead>
<th colspan="4"><h3>Вспомогательное оборудование</h3></th>
</thead>
{foreach $fets as $related} 
  {include file='related_view_list.tpl'} 
{/foreach}  
{/if}
</table>

{/if}

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