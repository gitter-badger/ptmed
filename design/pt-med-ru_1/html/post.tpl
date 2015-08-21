{* Страница отдельной записи блога *}

{* Канонический адрес страницы *}
{$canonical="/news/{$post->url}" scope=parent}

<h1 data-post="{$post->id}">{$post->name|escape}</h1>

{$post->text}
<p>{$post->date|date}</p>

<div id="back_forward">
    <div class="prev">{if $prev_post}←&nbsp;<a class="prev_page_link" href="news/{$prev_post->url}">{$prev_post->name}</a>{/if}</div>
    <div class="next">{if $next_post}<a class="next_page_link" href="news/{$next_post->url}">{$next_post->name}</a>&nbsp;→{/if}</div>	
</div>