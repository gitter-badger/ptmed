{strip}
<!DOCTYPE html>
<html lang="ru">
<head>
	<base href="{$config->root_url}/"/>
	<title>{$meta_title|escape}</title>
	
	{* Метатеги *}
	<meta charset="UTF-8" />
	<meta name="description" content="{$meta_description|escape}" />
	<meta name="keywords" content="{$meta_keywords|escape}" />
	<meta name="viewport" content="width=1024"/>
	
	{* Канонический адрес страницы *}
	{if isset($canonical)}<link rel="canonical" href="{$config->root_url}{$canonical}"/>{/if}
        
        {* Скрипт для работы html5 тегов в старых браузерах *}
        <!--[if lt IE 9]><script src="/design/{$settings->theme|escape}/js/html5.js"></script><![endif]-->
	
	{* Стили *}
	<link href="design/{$settings->theme|escape}/css/style.css" rel="stylesheet" type="text/css" media="screen"/>
	<link href="design/{$settings->theme|escape}/images/favicon.ico" rel="icon" type="image/x-icon"/>
	<link href="design/{$settings->theme|escape}/images/favicon.ico" rel="shortcut icon" type="image/x-icon"/>
        
        {* Стили подключаемых шрифтов в картинках *}
        <link rel="stylesheet" href="design/{$settings->theme|escape}/font-awesome-4.3.0/css/font-awesome.min.css">
        
        {* Стили Nivo Slider *}
        {if $module|in_array:['MainView']}
        <link rel="stylesheet" href="design/{$settings->theme|escape}/nivo-slider/nivo-slider.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="design/{$settings->theme|escape}/nivo-slider/themes/default/default.css" type="text/css" media="screen" />
        {/if}    

	{* JQuery *}
	<script src="js/jquery/jquery.js"  type="text/javascript"></script>
        {if $module|in_array:['MainView']}
        <script type="text/javascript" src="design/{$settings->theme|escape}/nivo-slider/jquery.nivo.slider.js"></script>
	{/if} 
	
	{* Ctrl-навигация на соседние товары *}
	<script type="text/javascript" src="js/ctrlnavigate.js"></script>           
	
	{* Аяксовая корзина *}
	<script src="design/{$settings->theme}/js/jquery-ui.min.js"></script>
	
	{* js-проверка форм *}
	<script src="js/baloon/js/baloon.js" type="text/javascript"></script>
	<link   href="js/baloon/css/baloon.css" rel="stylesheet" type="text/css" /> 
				
</head>

<body class="body">

    
{* Шапка сайта *}    
<header>
    <div class="wrap">
    <a href="/" class="logo">
        <img src="design/{$settings->theme|escape}/images/logo.png" title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}"/>
        <span>физиотерапия<i class="fa fa-circle"></i>реабилитация<i class="fa fa-circle"></i>спа</span>
    </a>
    
    <div id="search">
	<form action="products">
            <input class="input_search" type="text" name="keyword" value="{$keyword|escape}" placeholder="Поиск товара"/>
            <input class="button_search" value="Найти" type="submit" />
	</form>
    </div>
    
    <div id="contact">
        <i class="fa fa-phone"></i>
	<span>+7 (812) 321 67 80<p><a href="/obratnyj-zvonok">обратный звонок</a></p></span>

    </div>
    <div class="clear"></div>        
    </div>
</header>

{* Меню и каталог *}
<nav>
    <div class="wrap">
    <ul>    
        <li><a href="/"><i class="fa fa-home"></i> Главная</a></li>
        <li><a href="/o-kompanii">О компании</a>
            <ul>
                <li><a href="/prezentatsiya">Презентация</a></li>
                <li><a href="/news">Наши проекты</a></li>
                <li><a href="/news">Мероприятия</a></li>
                <li><a href="/contact">Контакты</a></li>
            </ul>    
        </li>
	{function name=categories_tree}
            {if $categories}
		<ul>
            {foreach $categories as $c}
			{if $c->visible && !$c->clear && !$c->id|in_array:['38']}
            <li>
                <a {if $category->id == $c->id}class="selected"{/if} href="catalog/{$c->url}">{$c->name|escape}</a>
            {categories_tree categories=$c->subcategories}
            </li>
			{/if}
            {/foreach}
		</ul>
            {/if}
	{/function}
	{categories_tree categories=$categories}
    <ul>
        <li><a href="/reklamnye-materialy">Рекламные материалы</a>
            <ul>
                <li><a href="/katalogi">Каталоги</a></li>
                <li><a href="/buklety">Буклеты</a></li>
                <li><a href="/video">Видео</a></li>
                <li><a href="/fotoalbomy">Фотоальбомы</a></li>
            </ul>    
        </li>
        <li><a href="/contact">Контакты</a>
            <ul>
                <li><a href="/tsentralnyj-ofis-prodazh">Центральный офис продаж</a></li>
                <li><a href="/shema-proezda-sklada">Схема проезда склада</a></li>
                <li><a href="/regionalnye-predstaviteli">Региональные представители</a></li>
                <li><a href="/faqs">Вопрос-Ответ</a></li>
            </ul>    
        </li>
    </ul>  
    </div>
</nav>    

{* Тело страницы *}
<main>
    <div class="wrap">
    <article>
        
        {* Слайдер *}
        {if $module|in_array:['MainView']}
        <div class="slider-wrapper theme-default">
            <div id="slider" class="nivoSlider">
                <a href="#">
                    <img src="design/{$settings->theme}/images/banner-1.jpg" data-thumb="images/banner-1.jpg" alt=""  title="#htmlcaption-banner-1" />
                </a>
                <a href="#">
                    <img src="design/{$settings->theme}/images/banner-2.jpg" data-thumb="images/banner-2.jpg" alt="" title="#htmlcaption-banner-2" />
                </a>
                <a href="#">
                    <img src="design/{$settings->theme}/images/banner-3.jpg" data-thumb="images/banner-3.jpg" alt=""  title="#htmlcaption-banner-3" />
                </a>
                <a href="#">
                    <img src="design/{$settings->theme}/images/banner-4.jpg" data-thumb="images/banner-4.jpg" alt="" title="#htmlcaption-banner-4" />
                </a>
                <a href="#">
                    <img src="design/{$settings->theme}/images/banner-5.jpg" data-thumb="images/banner-5.jpg" alt=""  title="#htmlcaption-banner-5" />
                </a>
                <a href="#">
                    <img src="design/{$settings->theme}/images/banner-6.jpg" data-thumb="images/banner-6.jpg" alt=""  title="#htmlcaption-banner-6" />
                </a>
                <a href="#">
                    <img src="design/{$settings->theme}/images/banner-7.jpg" data-thumb="images/banner-7.jpg" alt=""  title="#htmlcaption-banner-7" />
                </a>
            </div>
            <div id="htmlcaption-banner-1" class="nivo-html-caption">
                <span>Название товара 1</span>
                <p>Текст-1 Нишевый проект оправдывает рыночный охват аудитории. Партисипативное планирование, в рамках сегодняшних воззрений, обуславливает метод изучения рынка.</p>
            </div>
            <div id="htmlcaption-banner-2" class="nivo-html-caption">
                <span>Название товара 2</span>
                <p>Текст-2 Рекламный макет, согласно Ф.Котлеру, одновременно искажает потребительский CTR. BTL консолидирует инвестиционный продукт, осознав маркетинг как часть производства.</p>
            </div>
            <div id="htmlcaption-banner-3" class="nivo-html-caption">
                <span>Название товара 3</span>
                <p>Текст-3 Служба маркетинга компании решительно индуцирует коллективный мониторинг активности.</p>
            </div>
            <div id="htmlcaption-banner-4" class="nivo-html-caption">
                <span>Название товара 4</span>
                <p>Текст-4 Анализ зарубежного опыта слабо специфицирует рейтинг. Потребление нетривиально. Фокус-группа уравновешивает конвергентный клиентский спрос.</p>
            </div>
            <div id="htmlcaption-banner-5" class="nivo-html-caption">
                <span>Название товара 5</span>
                <p>Текст-5 Рейт-карта, отбрасывая подробности, однообразно нейтрализует рекламоноситель.</p>
            </div>
            <div id="htmlcaption-banner-6" class="nivo-html-caption">
                <span>Название товара 6</span>
                <p>Текст-6 BTL консолидирует инвестиционный продукт, осознав маркетинг как часть производства.</p>
            </div>
            <div id="htmlcaption-banner-7" class="nivo-html-caption">
                <span>Название товара 7 </span>
                <p>Текст-7 Программа лояльности, на первый взгляд, оправдывает метод изучения рынка, не считаясь с затратами. </p>
            </div>
        </div>
        {/if}
        
        {$content|strip}
    </article>
    </div>
</main>

<div class="wrap">
{* Блок наши партнеры *}    
<h2>Наши партнеры</h2>
<ul class="partners">
<li><a href="/brands/chirana-progress"><img src="/files/uploads/chiranaprogress.jpg" alt="Chiranaprogress" /></a></li>     
<li><a href="/brands/unbeschaiden-baden-baden"><img src="/files/uploads/unbescheiden.jpg" alt="Unbescheiden Baden-Baden" /></a></li> 
<li><a href="/brands/vagnerplast"><img src="/files/uploads/vagnerplast.jpg" alt="Vagnerplast" /></a></li> 
<li><a href="/brands/neo-qi"><img src="/files/uploads/neoqi.jpg" alt="NeoQi" /></a></li> 
<li><a href="/brands/btl"><img src="/files/uploads/btl.jpg" alt="BTL" /></a></li>
<li><a href="/brands/hab-herrmann"><img src="/files/uploads/habherrmann.jpg" alt="Habherrmann" /></a></li> 
<li><a href="/brands/fysioteh"><img src="/files/uploads/fysiotech.jpg" alt="Fysiotech" /></a></li>
<li><a href="/brands/spitzner"><img src="/files/uploads/spitzner.jpg" alt="Spitzner" /></a></li> 
</ul> 
</div>

{* Футер сайта *}
<footer>
    <div class="wraps">
    <section>
        <div>
           <img src="design/{$settings->theme|escape}/images/logo.png" title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}"/> 
           <span>Компания «Физиотехника» – производство и продажа водолечебного оборудования, медицинской техники, услуги по их проектированию и строительству.</span>
           <del><!--LiveInternet counter--><script type="text/javascript">document.write("<a href='//www.liveinternet.ru/click' target=_blank><img src='//counter.yadro.ru/hit?t44.6;r" + escape(document.referrer) + ((typeof(screen)=="undefined")?"":";s"+screen.width+"*"+screen.height+"*"+(screen.colorDepth?screen.colorDepth:screen.pixelDepth)) + ";u" + escape(document.URL) + ";" + Math.random() + "' border=0 width=31 height=31 alt='' title='LiveInternet'><\/a>")</script><!--/LiveInternet--></del>
        </div>
        <ul class="info">
            <li><span>Информация</span></li>
            <li><a href="/o-kompanii">О компании</a></li>
            <li><a href="/catalog/produktsiya-pp-fiziotehnika">Наша продукция</a></li> 
            <li><a href="/catalog/produktsiya-partnerov">Продукция партнеров</a></li> 
            <li><a href="/reklamnye-materialy">Рекламные материалы</a></li> 
            <li><a href="/obratnyj-zvonok">Обратный звонок</a></li> 
        </ul>    
        <ul class="no-border">
            <li><span>Контакты</span></li>
            <li><i class="fa fa-map-marker"></i><ins>197198, г.Санкт-Петербург, ул. Съезжинская, д. 23, пом. 25, (а/я 105)</ins></li>
            <li><i class="fa fa-phone"></i><ins>(812) 321 67 80 (многоканальный)<br/>(812) 232 27 29</ins></li>
            <li><i class="fa fa-envelope-o"></i><ins><a href="mailto:mail@pt-med.ru">mail@pt-med.ru</a></ins></li>
            <li><i class="fa fa-skype"></i><ins>skype_ptmed</ins></li>
        </ul>    
        
    </section>
    </div>       

    <div class="wrapf"><p>&#169; ООО «Физиотехника», 2007-2015</p></div>
    
</footer>    

	{* Автозаполнитель поиска *}
	{literal}
	<script src="js/autocomplete/jquery.autocomplete-min.js" type="text/javascript"></script>
	<style>
		.autocomplete-suggestions{
		background-color: #ffffff;
		overflow: hidden;
		border: 1px solid #e0e0e0;
		overflow-y: auto;
		}
		.autocomplete-suggestions .autocomplete-suggestion{cursor: default;}
		.autocomplete-suggestions .selected { background:#F0F0F0; }
		.autocomplete-suggestions div { padding:2px 5px; white-space:nowrap; }
		.autocomplete-suggestions strong { font-weight:normal; color:#3399FF; }
	</style>	
	<script>
	$(function() {
		//  Автозаполнитель поиска
		$(".input_search").autocomplete({
			serviceUrl:'ajax/search_products.php',
			minChars:1,
			noCache: false, 
			onSelect:
				function(suggestion){
					 $(".input_search").closest('form').submit();
				},
			formatResult:
				function(suggestion, currentValue){
					var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
					var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
	  				return (suggestion.data.image?"<img align=absmiddle src='"+suggestion.data.image+"'> ":'') + suggestion.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
				}	
		});
	});
	</script>
        
    <script type="text/javascript">
    $(window).load(function() {
        $('#slider').nivoSlider({
            effect: 'fade',
        });
    });
    </script>
	{/literal}
    
    {if $module|in_array:['ProductView','PageView']}    
    {* Увеличитель картинок *}
    {literal}
    <script type="text/javascript" src="js/fancybox/jquery.fancybox.pack.js"></script>
    <link rel="stylesheet" href="js/fancybox/jquery.fancybox.css" type="text/css" media="screen" />

    <script>
    $(function() {
            // Раскраска строк характеристик
            $(".features tr:even").addClass('even');

            // Зум картинок
            $("a.zoom").fancybox({
                    prevEffect	: 'fade',
                    nextEffect	: 'fade'});
            });
    </script>
    {/literal}    
    {/if}
 
{if $category->id|in_array:['34']} 
 {literal}
 <script type="text/javascript">
$(document).ready(function(){

$('body').append('<div id="catalog-ral-overlay"></div><div id="catalog-ral-lightbox"></div>');

var allheight = $(document).height();
var windowheight = $(window).height()/2;

$("#catalog-ral li").click(function(event){

var backcolor = $(this).css("background-color");
var allscroll = $(document).scrollTop();

$('#catalog-ral-overlay').css({
backgroundColor: "#000",
opacity: "0.7",
height: allheight
}).fadeIn("fast");

$('#catalog-ral-lightbox').text($(this).html()).css({
backgroundColor: backcolor,
top: allscroll + windowheight
}).fadeIn("fast");

});

$("#catalog-ral-overlay").click(function(event){
$(this).fadeOut("fast");
$('#catalog-ral-lightbox').fadeOut("fast");
});
$("#catalog-ral-lightbox").click(function(event){
$('#catalog-ral-overlay').fadeOut("fast");
$(this).fadeOut("fast");
});

});
</script>
 {/literal}
 {/if}
        
</body>
</html>
{/strip}