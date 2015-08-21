{* Список товаров *}

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
</div>

{* Заголовок страницы *}
{if $keyword}
<h1>Поиск {$keyword|escape}</h1>
{elseif $page}
<h1>{$page->name|escape}</h1>
{else}
<h1>{$category->name|escape} {$brand->name|escape} {$keyword|escape}</h1>
{/if}


{if $category->id == "6"}
<div class="price-sheet">    
<a href="price/{$category->url}">Посмотреть цены</a>    
</div> 
{/if}

{* Вывод подкатегорий *}
{if $category->subcategories && 0}
    <ul class="subnav">
    {foreach from=$category->subcategories item=n}
        <li>
            <a href="catalog/{$n->url}">
                <div>
                {if $n->image}
                    <img src="{$config->categories_images_dir}{$n->image}" alt="{$n->name|escape}">
                {/if}
                </div>
                <span>
                {$n->name}
                </span>
            </a>
        </li>
    {/foreach}
    </ul>
{/if}

{if $products}

<div class="price-sheet">    
<a href="price/{$category->url}">Посмотреть цены</a>    
</div>    
    
<ul class="products">
    {foreach $products as $product}
	<li>
            <a href="products/{$product->url}">
            {if $product->image}
		<div class="image">
                    <img src="{$product->image->filename|resize:250:250}" alt="{$product->name|escape}"/>
		</div>
            {/if}
		<span>
                    {$product->name|escape}
                </span>
            </a>    
	</li>
    {/foreach}		
</ul>

{*
{include file='pagination.tpl'}	
*}

{if $pin_products}
    <ul class="subnav">
    {foreach from=$pin_products item=p}
        <li>
            <a href="products/{$p->url}">
                <div>
                {if $p->image}
                    <img src="{$p->image->filename|resize:250:250}" alt="{$p->name|escape}"/>
                {/if}
                </div>
                <span>
                {$p->name}
                </span>
            </a>
        </li>
    {/foreach}
    </ul>
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