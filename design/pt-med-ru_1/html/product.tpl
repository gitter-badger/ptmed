{* Страница товара *}

{* Канонический адрес страницы *}
{$canonical="/products/{$product->url}" scope=parent}

<div id="path">
	<a href="./">Главная</a>
	{foreach from=$category->path item=cat}
    {if !$cat->clear}
	&#187; <a href="catalog/{$cat->url}">{$cat->name|escape}</a>
    {/if}
	{/foreach}
	{if $brand}
	&#187; <a href="catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a>
	{/if}
	&#187;  {$product->name|escape}                
</div>

<div class="product {if $product->dop}dop{/if} {if $product->featured}vspom{/if} {if $product->featured && $product->variants|count > 1} vspom-many{/if}">

    <div class="top-block">
        {if $product->image}
        <div class="image-block">
            <div class="image">
                <a href="{$product->image->filename|resize:1024:768:w}" class="zoom" rel="group"><img src="{$product->image->filename|resize:480:360}" alt="{$product->product->name|escape}" /></a>
           </div>
        </div>
        {/if}

        {assign var="ifconf1" value=(($product->variants|count > 1 && $product->featured) && !$product->configurator) || (($product->variants|count > 1 && $product->dop) && !$product->configurator) }
        {assign var="ifconf2" value=$product->variants|count > 1 || $product->configurator || $featureds || $dops }

        <div class="right-block {if !$product->image}right-block-full{/if}">
            {if !$product->featured || $product->variants|count < 2}
                <div class="description">
                    <h1>{$product->name|escape}</h1>
                    {foreach $product->variants as $v}
                        <div class="price-sheet">
                            {if $v->price > 0}<span class="price">Цена: <strong id="price_ru" data-price="{$v->price}">{if $product->variants|count > 1 || $product->featured || $dops}от{/if} {$v->price|convert} {$currency->sign|escape}</strong></span>
                                <span class="price_eur" id="price_eur" data-price="{$v->price|convert:EUR}">{$v->price|convert:EUR} {$eur->sign|escape}</strong></span>
                            {else}
                                <span class="price">Цена по запросу</span>
                            {/if}

                            <div class="btn_block">
                                {if !$product->dop}
                                    {if !$ifconf1 && $ifconf2}
                                        <a class="btn-buy" id="buybtn" role="button" href="#configurator">Купить</a>
                                        {else}
                                        <a class="btn-buy buy-a" id="buybtn" role="button" href="/cart">Купить</a>
                                    {/if}
                                {/if}
                                <a class="price-btn" role="button" href="price/{$category->url}">Прайс-лист</a>
                            </div>
                        </div>
                        {if $product->dop}
                            <div class="conf_title"><strong>Дополнительная опция может быть приобретена только в комплекте с оборудованием</strong></div>
                        {/if}
                        {break}
                    {/foreach}
                </div>
            {else}
                {if !$product->featured}
                <div class="description">
                    <h1>{$product->name|escape}</h1>
                </div>
                {/if}
            {/if}

            <div class="images">
                {if $product->images|count>1}
                    {foreach $product->images|cut as $i=>$image}
                        <a href="{$image->filename|resize:1024:768:w}" class="zoom" rel="group"><img src="{$image->filename|resize:110:110}" alt="{$product->name|escape}" /></a>
                    {/foreach}
                {/if}
            </div>
        </div>
    </div>

    <div class="tab-block {if !$product->image}right-block-full{/if} {if !$ifconf1 && $ifconf2} conf{/if}">

        {*кофигуратор без вкладок для вспомогательных и дополнительных товаров*}
        {if $ifconf1}
            <div>{include file="configurator.tpl"}</div>
            <div>{include file="description.tpl"}</div>
        {else}
            {*кофигуратор на вкладках*}
            {if $ifconf2}
            <span id="configurator">
                <div class="product-tabs">
                    <ul class="nav nav-tabs" id="tabs">
                        {if $product->body}
                            <li class="dtab active"><a href="#description" data-toggle="tab"><span class="glyphicon glyphicon-th-list"></span> Описание</a></li>
                        {/if}
                        {if $product->features}
                            <li class="ttab"><a href="#specifications" data-toggle="tab"><span class="glyphicon glyphicon-th-list"></span> Характеристики</a></li>
                        {/if}
                        {if !($product->body || $product->features)}
                            <li class="ctab active"><a href="#configurator_tab" data-toggle="tab"><span class="glyphicon glyphicon-pencil"></span> Цены</a></li>
                        {else}
                            <li class="ctab"><a href="#configurator_tab" data-toggle="tab"><span class="glyphicon glyphicon-pencil"></span> Цены</a></li>
                        {/if}
                    </ul>
                </div>
                <div class="tab-content">
                    {if $product->body}
                        <div class="tab-pane cdtab active" id="description">
                            {include file="description.tpl"}
                        </div>
                    {/if}
                    {if $product->features}
                    <div class="tab-pane cdtab" id="specifications">
                        <div class="table-block features">
                            <h2 class="title">Технические характеристики</h2>
                            <table class="features">
                                {foreach $product->features as $f}
                                    <tr>
                                        <td>{$f->name}</td>
                                        <td>{$f->value}</td>
                                    </tr>
                                {/foreach}
                            </table>
                        </div>
                    </div>
                    {/if}
                    {if !($product->body || $product->features)}
                        <div class="tab-pane cctab active 55" id="configurator_tab">
                            {include file="configurator.tpl"}
                            <div class="btn_block">
                                <a id="order-btn" class="btn-buy order-btn" id="buybtn" role="button" href="/cart">Сделать заказ</a>
                            </div>
                        </div>
                    {else}
                        <div class="tab-pane cctab " id="configurator_tab">
                            {include file="configurator.tpl"}
                            <div class="btn_block">
                                <a id="order-btn" class="btn-buy order-btn" id="buybtn" role="button" href="/cart">Сделать заказ</a>
                            </div>
                            </div>
                    {/if}
                </div>
            </span>
            {else}
                <div class="tab-content">
                    {if $product->body}
                    <div class="tab-pane cdtab active" id="description">
                        {include file="description.tpl"}
                    </div>
                    {/if}
                </div>
            {/if}
        {/if}
        {literal}
            <script>
                $(function(){
                    $('#myTab a').click(function (e) {
                        e.preventDefault()
                        $(this).tab('show')
                    });
                    $('a').click(function(){
                        $('html, body').animate({
                            scrollTop: $( $.attr(this, 'href') ).offset().top}, 500);
                        return false;
                    });
                });
            </script>
            <script>
                $(function () {
                    if ($('#buybtn').length > 0) {
                        $('#buybtn').click(function () {
                            $('.dtab').removeClass('active');
                            $('.ctab').addClass('active');
                            $('.cdtab').removeClass('active');
                            $('.cctab').addClass('active');
                            $('html, body').animate({scrollTop: $($(this).attr('href')).offset().top}, 600);
                            return false;
                        });
                    }
                });
            </script>
        {/literal}

        {literal}
        <script>
            $('#order-btn, .buy-a').click(function () {
                if ($('#product-form').find('input[name=variant]:checked').size() > 0)
                    var variant = $('#product-form').find('input[name=variant]:checked').val();
                    send(variant);

                $("#product-form input").each(
                        function(){
                            var checked = $(this).prop('checked');
                            if(checked){
                                send($(this).val());
                            }
                        }
                );

                return true;

                function send(variant) {
                    $.ajax({
                        url: "ajax/cart.php",
                        data: {variant: variant},
                        dataType: 'json',
                        success: function (data) {
                        }
                    });
                }
            });

        </script>
        {/literal}
    </div>

    {*{include file="request.tpl"}*}
</div>