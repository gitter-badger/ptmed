{* Главная страница магазина *}

{* Для того чтобы обернуть центральный блок в шаблон, отличный от index.tpl *}
{* Укажите нужный шаблон строкой ниже. Это работает и для других модулей *}
{$wrapper = 'index.tpl' scope=parent}

{* Канонический адрес страницы *}
{$canonical="" scope=parent}
 
<section class="section-main">
{* Блок новостей *}
{get_posts var=last_posts limit=3}
{if $last_posts}
<h2>Новости</h2>    
    <div id="blog_menu">
            <ul>
                {foreach $last_posts as $post}
                    <li data-post="{$post->id}">
                        <a href="news/{$post->url}">
                        {$post->annotation}
                        <span>{$post->name|escape}</span>
                        <time datetime="{$post->date|date_format:'%Y-%m-%d'}">{$post->date|date}</time> 
                        </a>
                    </li>
                {/foreach}
            </ul>
            <ins><a href="news"><i class="fa fa-coffee"></i>Читать все новости</a></ins>
    </div>
{/if}
</section>

<aside class="aside-main">
 <a href="/files/uploads/price.zip" target="_blank"><i class="fa fa-file-excel-o"></i>Скачать прайс лист</a>
 <a href="/files/uploads/katalog.pdf" target="_blank" class="no-right"><i class="fa fa-file-pdf-o"></i>Скачать каталог оборудования</a>
</aside>   

   

{* Заголовок страницы *}
<h1>{$page->header}</h1>

{* Тело страницы *} 
{$page->body}