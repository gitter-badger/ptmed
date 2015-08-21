{* Применение и описание товара *}
{if $product->body}
<div class="body">
<h2>Применение в медицинской практике</h2>
{$product->body}
{* Монтажные схемы, мертификаты и РУ (Используем краткое описание товара) *}
{if $product->annotation}
    <div class="annotation">
        <h2 class="title">Краткое описание, монтажные схемы, сертификаты и РУ</h2>
        <div class="annotation-src">
            {$product->annotation}
        </div>
    </div>
{/if}
</div>
{/if}