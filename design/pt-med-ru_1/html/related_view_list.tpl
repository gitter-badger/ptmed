{foreach $related->variants as $v}
<tr>
  <td></td>
  <td><a href="products/{$related->url}">{$related->name|escape}&nbsp;{if $v->name}{$v->name}{/if}</a></td>
  <td>{if $v->compare_price > 0} {$v->compare_price|convert} {/if}{$v->price|convert} {$currency->sign|escape}</td>
  <td>{$v->price|convert:EUR} €</td>
</tr>
{/foreach}
