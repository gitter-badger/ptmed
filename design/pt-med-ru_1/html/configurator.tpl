{* Конфигуратор *}

<div class="configurator">
    {if $product->featured}
        <div class="description">
            <h1>{$product->name|escape}</h1>
        </div>
    {/if}
    {if !$product->dop && !$product->featured}
        <div class="conf_title"><strong>Выберите нужную конфигурацию оборудования</strong></div>
    {/if}
    <div class="configurator {if $product->featured } vspom{/if}">
        <form id="product-form" class="variants" action="/cart">
    {if $product->variants|count > 0}
            {if $product->variants|count > 1}
            <div class="variants_desk">Варианты конфигурации:</div>
            <table class="table table-striped">
                <thead>
                    {foreach $product->variants as $v}
                    <tr>
                        {if !$product->featured}
                        <th class="variant_inp">
                            <input id="v_{$v->id}" name="variant" price_eur='{$v->price|convert:EUR}' price='{$v->price}' value="{$v->id}" type="radio" class="variant_radiobutton" {if $product->variant->id==$v->id}checked{/if}/>
                        </th>
                        {/if}
                        <th class="variant_name">
                            {if $product->featured}
                                <input id="v_{$v->id}" name="variant" price_eur='{$v->price|convert:EUR}' price='{$v->price}' value="{$v->id}" type="radio" class="variant_radiobutton" {if $product->variant->id==$v->id}checked{/if}/>
                            {/if}
                            {if $v->name}<label class="variant_name" for="product_{$v->id}">{$v->name} {if $category->id|in_array:['5']}&nbsp;(базовая комплектация){/if}</label>{/if}
                        </th>
                        <th class="price_ru">
                            {if $v->compare_price > 0}
                                {$v->compare_price|convert}
                            {/if}
                            {$v->price|convert}&nbsp;{$currency->sign|escape}
                        </th>
                        <th class="price_eur">
                            {$v->price|convert:EUR}&nbsp;{$eur->sign|escape}
                       </th>
                        {if $product->featured}
                        <th class="variant_btn">
                            <a class="btn-buy" role="button" href="#request" data-item="#v_{$v->id}" ">Купить</a>
                        </th>
                        {/if}
                   </tr>
                {/foreach}
                </thead>

            {else}
            <input id="v_{$v->id}" name="variant" price_eur='{$v->price|convert:EUR}' price='{$v->price}' value="{$v->id}" type="radio" class="variant_radiobutton" style="display: none" {if $product->variant->id==$v->id}checked{/if}/>
            <table class="table table-striped">
            {/if}

    {* Связанные товары *}
    {if $dops}

        <thead>
            <th class="table_title" colspan="4">Дополнительные опции</th>
        </thead>
        {foreach $related_products as $related_product}
        {if $related_product->variants|count > 0 && $related_product->dop}
        {foreach $related_product->variants as $v}
        <tr>
            <th>
                <input id="config_{$v->id}" name="config_dop_{$v->id}" price='{$v->price}' price_eur='{$v->price|convert:EUR}' value="{$v->id}" type="checkbox" class="variant_radiobutton" excluded="{$related_product->excluded}"/>
            </th>
            <td>
                <a id="config_dop_ref_{$v->id}" data-product="{$related_product->id}" href="products/{$related_product->url}">{$related_product->name|escape}&nbsp;{$v->name|escape}</a>
            </td>
            <td class="table_price_ru">
                {$v->price|convert} {$currency->sign|escape}
            </td>
            <th class="table_price_eur">
                {$v->price|convert:EUR} {$eur->sign|escape}
            </th>
        </tr>
        {/foreach}
        {/if}
        {/foreach}
        <thead>
            <th></th>
            <th></th>
            <th class="table_price_ru"><label id='total_dop'>0</label>&nbsp;{$currency->sign|escape}</th>
            <th class="table_price_eur"><label id='total_dop_eur'>0</label>&nbsp;{$eur->sign|escape}</th>
        </thead>
    {/if}

    {if $featureds}
    {* Вспомогательное оборудовпание *}
        <thead>
            <th class="table_title" colspan="4">Вспомогательное оборудование</th>
        </thead>
        {foreach $related_products as $related_product}
        {if $related_product->variants|count > 0 && $related_product->featured}
        {foreach $related_product->variants as $v}
        <tr>
            <th>
                <input id="config_{$v->id}" name="config_featured_{$v->id}" price='{$v->price}' price_eur='{$v->price|convert:EUR}' value="{$v->id}" type="checkbox" class="variant_radiobutton" excluded="{$related_product->excluded}"/>
            </th>
            <td>
                <a data-product="{$related_product->id}" href="products/{$related_product->url}">{$related_product->name|escape}&nbsp;{$v->name|escape}</a>
            </td>
            <td class="table_price_ru">
                {$v->price|convert}&nbsp;{$currency->sign|escape}
            </td>
            <td class="table_price_eur">
                {$v->price|convert:EUR}&nbsp;{$eur->sign|escape}
            </td>

        </tr>
        {/foreach}
        {/if}
        {/foreach}
        <thead>
            <th></th>
            <th></th>
            <th><label class="table_price_ru"><span id='total_featured'>0</span>&nbsp;{$currency->sign|escape}</label></th>
            <th><label class="table_price_eur"><span id='total_featured_eur'>0</span>&nbsp;{$eur->sign|escape}</label></th>
        </thead>
    {/if}
    {if !$product->featured}
    <tr>
        <td>
        <td class="itogo">Сумма:</td>
        <th class="table_price_ru"><label id='total'>0</label>&nbsp;{$currency->sign|escape}</th>
        <th class="table_price_eur"><label id='total_eur'>0</label>&nbsp;{$eur->sign|escape}</th>
    </tr>
    {/if}
    </table>
    </form>
    </div>
    <div class="clear"></div>

    {else}
        <p>Нет в наличии</p>
    {/if}

    {if $product->featured}
    {literal}
        <script>
            $('.btn-success').click(function () {
                $($(this).attr('data-item')).prop("checked", true);
                return false;
            });
        </script>
    {/literal}
    {/if}

    {literal}
    <script>
    $(function(){
        calc();
        $("input[name^=config_]").change(function(){
            calc();
            if($(this).attr('excluded'))
            {
                var excluded = $(this).attr('excluded').split(',');
                for(var i=0; i<excluded.length; i++)
                {
                    if(document.getElementById('config_'+excluded[i]) != null)
                        document.getElementById('config_'+excluded[i]).disabled = $(this).prop('checked');
                }
            }
        });
        $("input[name^=config_]").change(function(){
            calc();
        });
        $("input[name^=variant]").change(function(){
            calc();
        });


    });

    function calc(){
        var priceru = 0;
        var priceeur = 0;
        var total = parseInt(priceru);
        var total_eur = parseInt(priceeur);
        $("input[name^=variant]").each(
            function(indx){
                var checked = $(this).prop('checked');
                if(checked){
                    total += parseInt($(this).attr('price'));
                    total_eur += parseInt($(this).attr('price_eur').replace(' ',''));
                    $('input#variant').val($(this).val());
                }
            }
        );

        if (priceru == 0) { priceru = $("#price_ru").attr('data-price').replace(' ','');}
        if (priceeur == 0) { priceeur = $("#price_eur").attr('data-price').replace(' ','');}

        var total_dop = 0;
        var total_dop_eur = 0;
        var options = '';
        $("input[name^=config_dop_]").each(
            function(indx){
                var checked = $(this).prop('checked');
                if(checked){
                    total_dop += parseInt($(this).attr('price'));
                    total_dop_eur += parseInt($(this).attr('price_eur').replace(' ',''));
                    if(options)
                        options += ','+$(this).val();
                    else
                        options = $(this).val();
                }
            }
        );

        var total_featured = 0;
        var total_featured_eur = 0;
        $("input[name^=config_featured_]").each(
            function(indx){
                var checked = $(this).prop('checked');
                if(checked){
                    total_featured += parseInt($(this).attr('price'));
                    total_featured_eur += parseInt($(this).attr('price_eur').replace(' ',''));
                    if(options)
                        options += ','+$(this).val();
                    else
                        options = $(this).val();
                }
            }
        );

        $('input#options').val(options);
        $("#total_dop").html(total_dop);
        $("#total_dop_eur").html(total_dop_eur);
        $("#total_featured").html(total_featured);
        $("#total_featured_eur").html(total_featured_eur);
        $("label#total").html(total + total_dop + total_featured);
        $("label#total_eur").html(total_eur + total_dop_eur + total_featured_eur);
    }

    </script>
    {/literal}
</div>
