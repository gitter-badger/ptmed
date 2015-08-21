{* Шаблон текстовой страницы *}

{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=parent}

<!-- Заголовок страницы -->
<h1 data-page="{$page->id}">{$page->header|escape}</h1>

<!-- Тело страницы -->
{$page->body}

{if $page->url|in_array:['shema-proezda-sklada']}
<div id="map">
{literal} 
<script type="text/javascript" charset="utf-8" src="//api-maps.yandex.ru/services/constructor/1.0/js/?sid=Tml8igrdQ42ZugTxpxK4qLib_A9ixDBF&height=450"></script>
{/literal}
</div> 
{/if}