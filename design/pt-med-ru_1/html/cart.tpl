{* Шаблон корзины *}

{$meta_title = "Корзина" scope=parent}

<div class="purchases cart">
    {if $cart->purchases}
        <form method="post" name="cart">
            <div class="purchases-right-block">

                <h2>Адрес получателя</h2>

                <div class="form cart_form">
                    {if $error}
                        <div class="message_error">
                            {if $error == 'empty_name'}Введите имя{/if}
                            {if $error == 'empty_email'}Введите email{/if}
                            {if $error == 'captcha'}Капча введена неверно{/if}
                        </div>
                    {/if}

                    <label>Ф. И. О.</label>
                    <input name="name" type="text" value="{$name|escape}" data-format=".+" data-notice="Введите имя"/>

                    <label>Телефон</label>
                    <input name="phone" type="text" value="{$phone|escape}"/>

                    <label>Email</label>
                    <input name="email" type="text" value="{$email|escape}" data-format="email"
                           data-notice="Введите email"/>

                    {*<label>Адрес доставки</label>*}
                    <input name="address" type="hidden" value="{$address|escape}"/>

                    <div class="requisites">
                        <label>Реквизиты</label>
                        <textarea name="comment" id="order_comment">{$comment|escape}</textarea>
                    </div>

                    {*<div class="captcha"><img src="captcha/image.php?{math equation='rand(10,10000)'}" alt='captcha'/>*}
                    {*</div>*}
                    {*<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value=""*}
                           {*data-format="\d\d\d\d" data-notice="Введите капчу"/>*}

                    <input type="submit" name="checkout" class="btn-checkout" value="Оформить заказ">
                </div>
            </div>
            <div class="purchases-left-block">
                {* Список покупок *}

                <h1>
                    {if $cart->purchases}В корзине {$cart->total_products} {$cart->total_products|plural:'товар':'товаров':'товара'}
                    {else}Корзина пуста{/if}
                </h1>

                <table id="purchases">

                    {foreach from=$cart->purchases item=purchase}
                        <tr>
                            {* Изображение товара *}
                            <td class="image">
                                {$image = $purchase->product->images|first}
                                {if $image}
                                    <a href="products/{$purchase->product->url}"><img
                                                src="{$image->filename|resize:50:50}" alt="{$product->name|escape}"></a>
                                {/if}
                            </td>

                            {* Название товара *}
                            <td class="name">
                                <a href="products/{$purchase->product->url}">{$purchase->product->name|escape}</a>
                            </td>

                            {* Количество *}
                            <td class="amount">
                                <select name="amounts[{$purchase->variant->id}]" onchange="document.cart.submit();">
                                    {section name=amounts start=1 loop=$purchase->variant->stock+1 step=1}
                                        <option value="{$smarty.section.amounts.index}"
                                                {if $purchase->amount==$smarty.section.amounts.index}selected{/if}>{$smarty.section.amounts.index} {$settings->units}</option>
                                    {/section}
                                </select>
                            </td>

                            {* Цена *}
                            <td class="price">
                                <div class="p_ru">{($purchase->variant->price*$purchase->amount)|convert}&nbsp;{$currency->sign}</div>
                                {*<div class="p_eur">{($purchase->variant->price*$purchase->amount)|convert:EUR}&nbsp;{$eur->sign|escape}</div>*}
                            </td>

                            {* Удалить из корзины *}
                            <td class="remove">
                                <a href="cart/remove/{$purchase->variant->id}"><img src="design/{$settings->theme}/images/trash_font_awesome.svg" alt="" /></a>
                            </td>

                        </tr>
                    {/foreach}
                    {if $user->discount}
                        <tr>
                            <th class="image"></th>
                            <th class="name">скидка</th>
                            <th class="price"></th>
                            <th class="amount"></th>
                            <th class="price">
                                {$user->discount}&nbsp;%
                            </th>
                            <th class="remove"></th>
                        </tr>
                    {/if}

                </table>
                <div class="purchases-total-block">
                    <div class="c30"> &nbsp; </div>
                    <div class="c30"> &nbsp; </div>
                    <div class="c40 text-align-right">Итого:&nbsp;{$cart->total_price|convert}&nbsp;{$currency->sign}</div>
                </div>
            </div>
        </form>
    {else}
        В корзине нет товаров
    {/if}

</div>
