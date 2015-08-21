{* Список записей блога *}

{* Канонический адрес страницы *}
{$canonical="/news" scope=parent}

<!-- Заголовок /-->
<h1>{$page->name}</h1>

{include file='pagination.tpl'}

    <div id="blog">
            <ul>
                {foreach $posts as $post}
                    <li data-post="{$post->id}">
                        <a href="news/{$post->url}">
                        {$post->annotation}
                        <span>{$post->name|escape}</span>
                        <time datetime="{$post->date|date_format:'%Y-%m-%d'}">{$post->date|date}</time> 
                        </a>
                    </li>
                {/foreach}
            </ul>
    </div>  

{include file='pagination.tpl'}
          