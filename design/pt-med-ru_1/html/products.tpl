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

{if $products}
<div class="price-sheet"><a class="btn btn-default" role="button" href="price/{$category->url}">Посмотреть цены</a></div>
{/if}

{*id категории продукции партнеров*}
{assign var="cat_id" value="115"}

{if $category->path[0]->id == $cat_id}
    <div class="filter">
        {get_brands var=all_brands}
        {if $all_brands}
            <div class="brands">
                <ul>
                    <li class="brand-li"><a class="brand-link active" href="brands/all">Все бренды</a></li>
                {foreach $all_brands as $b}
                    <li class="brand-li"><a class="brand-link" href="brands/{$b->url}">{$b->name}</a></li>
                {/foreach}
                </ul>
            </div>
        {/if}

        <div class="category">
            {if $category->subcategories}
                <ul class="category-filter-menu">
                    {foreach from=$category->subcategories item=n}
                        {if $n->visible}
                            <li><a class="category-link" href="catalog/{$n->url}">{$n->name}</a></li>
                        {/if}
                    {/foreach}
                </ul>
            {/if}
        </div>
        <!-- Все бренды (The End)-->
    </div>
{/if}

<ul class="{if $category->path[0]->id == $cat_id}filter_cont{/if} subnav">

{if !($category->path[0]->id == $cat_id)}
{* Вывод подкатегорий *}
    {if $category->subcategories}
        {foreach from=$category->subcategories item=n}
            {if $n->visible}
                <li>
                    <a href="catalog/{$n->url}">
                        <div class="image">
                            {if $n->image}
                                <img src="{$config->categories_images_dir}{$n->image}" alt="{$n->name|escape}">
                            {else}
                                <img class="no-image" src="design/{$settings->theme|escape}/images/no-image.png" alt="">
                            {/if}
                        </div>
                        <span>
                        {$n->name}
                        </span>
                    </a>
                </li>
            {/if}
        {/foreach}
    {/if}
{/if}

{if $products && $category->show_products}
    {foreach $products as $product}
        <li>
            <a href="products/{$product->url}">
                {if $product->image}
                    <div class="image">
                        <img src="{$product->image->filename|resize:250:250}" alt="{$product->name|escape}"/>
                    </div>
                {else}
                    {if $product->featured}
                        <div class="image">
                            <img class="no-image" src="design/{$settings->theme|escape}/images/invertory-2.jpg" alt="">
                        </div>
                    {else}
                        <div class="image">
                            <img class="no-image" src="design/{$settings->theme|escape}/images/no-image.png" alt="">
                        </div>
                    {/if}
                {/if}
                <span>
       {$product->name|escape}
    </span>
            </a>
        </li>
    {/foreach}
{/if}

{if $pin_products}
    {foreach from=$pin_products item=p}
        <li>
            <a href="products/{$p->url}">
                <div class="image">
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
{/if}

</ul>


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
