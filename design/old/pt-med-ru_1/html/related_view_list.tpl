{foreach $related->variants as $v}
<div class="price-list-related-line">
  <div class="price-list-related-line-title">
      <a href="products/{$related->url}">{$related->name|escape}&nbsp;{if $v->name}{$v->name}{/if}</a>
  </div>
  <div class="price-list-related-line-price">
      {if $v->compare_price > 0} {$v->compare_price|convert} {/if}{$v->price|convert} {$currency->sign|escape}
  </div>
  <div class="price-list-related-line-price-eur">
      {$v->price|convert:EUR} €
  </div>
</div>
{/foreach}
