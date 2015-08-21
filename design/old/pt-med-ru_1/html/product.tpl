<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="js/bootstrapvalidator/bootstrapValidator.css"/>
<script src="js/bootstrapvalidator/bootstrapValidator.js"></script>
<script src="js/mask/jquery.maskedinput.js"></script>
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

<h1>{$product->name|escape}</h1>


<div class="product">

{* Большое фото *}
    {if $product->image}
	<div class="image">
            <a href="{$product->image->filename|resize:1024:768:w}" class="zoom" rel="group"><img src="{$product->image->filename|resize:480:360}" alt="{$product->product->name|escape}" /></a>
	</div>
    {/if}


{* Дополнительные фото товара *}    
    {if $product->images|count>1}
    <div class="images">
            {foreach $product->images|cut as $i=>$image}
                    <a href="{$image->filename|resize:1024:768:w}" class="zoom" rel="group"><img src="{$image->filename|resize:110:110}" alt="{$product->name|escape}" /></a>
            {/foreach}
    </div>
    {/if}

{* Ссылка на конфигуратор *}
<div class="price-sheet">    
    {if !$product->dop && !$product->featured}
    <a href="products/{$product->url}#konfigarator">Перейти к конфигуратору</a>
    {/if}
    <a href="price/{$category->url}">Сравнить цены</a>
</div>  
    
{* Применение и описание товара *}    
    <div class="description">
    {$product->body}
    </div>
    
{* Технические характеристики *}
    {if $product->features}
        <div class="table-block">
        <h2>Технические характеристики</h2>
	<table class="features">
	{foreach $product->features as $f}
	<tr>
		<td>{$f->name}</td>
		<td>{$f->value}</td>
	</tr>
	{/foreach}
	</table>
        </div>
    {/if}  
    
{* Монтажные схемы, мертификаты и РУ (Используем краткое описание товара) *} 
    {$product->annotation}
{if !$product->dop && !$product->featured}
{* Конфигуратор *}
<a id="konfigarator"></a>
<h2>Конфигуратор оборудования</h2>
<p><b>Выберите нужное вам оборудование и отправьте нам запрос - мы перезвоним вам через 5 минут.</b></p>
<div class="configurator">
    <form class="variants" action="/cart">
{if $product->variants|count > 0}
        <table>
            {foreach $product->variants as $v}
            <tr>
                <td>
                    <input id="product_{$v->id}" name="variant" price_eur='{$v->price|convert:EUR}' price='{$v->price}' value="{$v->id}" type="radio" class="variant_radiobutton" {if $product->variant->id==$v->id}checked{/if}/>
                </td>  
                <td>
                    {$product->name|escape} {if $category->id|in_array:['5']}&nbsp;(базовая комплектация){/if}
                    {if $v->name}<label class="variant_name" for="product_{$v->id}">{$v->name}</label>{/if}
                </td>
                <td>
                    {if $v->compare_price > 0} 
                        {$v->compare_price|convert} 
                    {/if}
                    {$v->price|convert} {$currency->sign|escape}
                </td>
                <td>
                    {$v->price|convert:EUR} {$eur->sign|escape}
               </td> 
            </tr>
            {/foreach}
        </table>
    {else}
            <p>Нет в наличии</p>
    {/if}
    
{* Связанные товары *}
{if $dops}
<h3>Дополнительные опции</h3>
<table>
{foreach $related_products as $related_product}
{if $related_product->variants|count > 0 && $related_product->dop}
	{foreach $related_product->variants as $v}
    <tr>
        <td>
            <input id="config_dop_{$v->id}" name="config_dop_{$v->id}" price='{$v->price}' price_eur='{$v->price|convert:EUR}' value="{$v->id}" type="checkbox" class="variant_radiobutton" excluded="{$related_product->excluded}"/>
        </td> 
        <td>
            <a id="config_dop_ref_{$v->id}" data-product="{$related_product->id}" href="products/{$related_product->url}">{$related_product->name|escape}&nbsp;{$v->name|escape}</a>
        </td>        
        <td>
            {$v->price|convert} {$currency->sign|escape}
        </td>
        <td>
            {$v->price|convert:EUR} {$eur->sign|escape}
        </td> 
	</tr>
    {/foreach}
{/if}
{/foreach}
    <tr> 
        <td colspan="2" class="itogo">Сумма:</td>
        <td class="rub"><label id='total_dop'>0</label> {$currency->sign|escape}</td>  
        <td class="euro"><label id='total_dop_eur'>0</label>{$eur->sign|escape}</td>  
    </tr> 
</table>
{/if}  

{if $featureds}
{* Вспомогательное оборудовпание *}     
<h3>Вспомогательное оборудование</h3> 
<table>
{foreach $related_products as $related_product}
{if $related_product->variants|count > 0 && $related_product->featured}
    {foreach $related_product->variants as $v}
    <tr>
        <td>
            <input id="{$v->id}" name="config_featured_{$v->id}" price='{$v->price}' price_eur='{$v->price|convert:EUR}' value="{$v->id}" type="checkbox" class="variant_radiobutton"/>
        </td> 
        <td>
            <a data-product="{$related_product->id}" href="products/{$related_product->url}">{$related_product->name|escape}&nbsp;{$v->name|escape}</a>
        </td>        
        <td>
            {$v->price|convert} {$currency->sign|escape}
        </td>
        <td>
            {$v->price|convert:EUR} {$eur->sign|escape}
        </td> 
    </tr>
    {/foreach}
{/if}
{/foreach}
    <tr>
        <td colspan="2" class="itogo">Сумма:</td>
        <td class="rub"><label id='total_featured'>0</label> {$currency->sign|escape}</td>  
        <td class="euro"><label id='total_featured_eur'>0</label>{$eur->sign|escape}</td>  
    </tr> 
</table> 
{/if} 

<h3></h3> 
<table>
    <tr>
        <td class="itogo">Сумма:</td>
        <td class="rub"><label id='total'>0</label> {$currency->sign|escape}</td>  
        <td class="euro"><label id='total_eur'>0</label>{$eur->sign|escape}</td>  
    </tr> 
</table> 
</form> 
</div>    
{/if}
<div class="request-me"><p><a href="#request" data-toggle="modal">Отправить запрос</a></p></div>     
</div>

<div class="modal fade" id="request" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
<div class="modal-dialog">
<div class="modal-content">

<form id="defaultForm" class="form-horizontal" role="form" method="post" action="ajax/sendRequest.php">

<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
<h3 class="modal-title">Мы перезвоним через 15 минут</h3>
</div>
<div class="modal-body">
<p>

<div class="form-group">
<label class="col-md-2 control-label">Имя</label>
<div class="col-md-10">
<input name="name" type="name" class="form-control" placeholder="Имя">
</div>
</div>
<div class="form-group">
<label class="col-md-2 control-label">Е-майл</label>
<div class="col-md-10">
<input name="email" type="email" class="form-control" placeholder="ваш@email.ru">
</div>
</div>
<div class="form-group">
<label class="col-md-2 control-label">Телефон</label>
<div class="col-md-10">
<input id="phone" name="phone" type="phone" class="form-control" placeholder="81234567890">
</div>
</div>
    
<input type="hidden" id="options" name="options" value=""/>
<input type="hidden" id="variant" name="variant" value=""/>
<input type="hidden" id="product" name="product" value="{$product->id}"/>

</p>
</div>
<div class="modal-footer">
<button id="submitBtn" type="submit" class="btn btn-default" name="submit">Отправить запрос</button>
<button id="closeBtn" style="display:none" type="button" class="btn btn-default" data-dismiss="modal">Закрыть окно</button>
</div>

</form>

</div>
</div>
</div>

{literal}
<script>
$(function(){
    calc();
    $("input[name^=config_dop]").change(function(){
        if($(this).attr('excluded'))
        {
            var excluded = $(this).attr('excluded').split(',');
            for(var i=0; i<excluded.length; i++) 
            {
                document.getElementById('config_dop_'+excluded[i]).disabled = $(this).prop('checked');
            }
        }
    });
    $("input[name^=config_]").change(function(){
        calc();
    });
    $("input[name^=variant]").change(function(){
        calc();
    });

    $('#defaultForm').bootstrapValidator({
        live: 'enabled',
        submitHandler: function(validator, form, submitButton) {
            $('#closeBtn').show();
            $(form).ajaxSubmit( {
                success: function() {
                    $('#closeBtn').show();
                },
                failed: function() {
                    $('#closeBtn').show();
                }
            });
        },
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            name: {
                validators: {
                    notEmpty: {
                        message: 'Это поле не может быть пустым'
                    }
                }
            },
            email: {
                validators: {
                    notEmpty: {
                        message: 'Это поле не может быть пустым'
                    },
                    emailAddress: {
                        message: 'Вы указали неверный адрес email'
                    }
                }
            },
            phone: {
                threshold: 5,
                validators: {
                    notEmpty: {
                        message: 'Это поле не может быть пустым'
                    },
                    phone: {
                        message: 'Неправильный формат телефона',
                        country: 'RU'
                    }
                }
            }
        }
    });

});

function calc(){
    var total = 0;
    var total_eur = 0;
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
    
    var total_dop = 0;
    var total_dop_eur = 0;
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
    $("label#total_dop").html(total_dop);
    $("label#total_dop_eur").html(total_dop_eur);
    $("label#total_featured").html(total_featured);
    $("label#total_featured_eur").html(total_featured_eur);
    $("label#total").html(total + total_dop + total_featured);
    $("label#total_eur").html(total_eur + total_dop_eur + total_featured_eur);
}

</script>
{/literal}


