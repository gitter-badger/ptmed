<div class="modal fade" id="callback" role="dialog" aria-labelledby="callbackModalLabel" aria-hidden="true">
<div class="modal-dialog">
<div class="modal-content">

<form id="callbackForm" class="form-horizontal" role="form" method="post" action="ajax/callBack.php">

<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
<h3 class="modal-title">Мы перезвоним через 15 минут</h3>
</div>
<div class="modal-body">
<p>
<p id="errorMessage" class="bg-danger" style="display:none;">При отправке запроса произошли ошибки.</p>
<p id="successMessage" class="bg-success" style="display:none;">Ваш запрос получен нами, мы перезвоним через 15 минут.</p>
<div class="form-group">
<label class="col-md-2 control-label">Имя</label>
<div class="col-md-10">
<input name="cb_name" type="cb_name" class="form-control" placeholder="Имя">
</div>
</div>
<div class="form-group">
<label class="col-md-2 control-label">Телефон</label>
<div class="col-md-10">
<input id="cb_phone" name="cb_phone" type="phone" class="form-control" placeholder="81234567890">
</div>
</div>
    
<input type="hidden" id="cb_url" name="cb_url" value=""/>

</p>
</div>
<div class="modal-footer">
<button id="cb_submitBtn" type="submit" class="btn btn-lg btn-success" name="submit">Позвоните мне</button>
<button id="cb_closeBtn" style="display:none" type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
</div>

</form>

</div>
</div>
</div>

{literal}
<script>
$(function(){
    $('#callbackForm').bootstrapValidator({
        live: 'enabled',
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
    })
	.on('success.form.bv', function(e) {
        var thisForm = $(this), parent = thisForm.parent();
        e.preventDefault();
  		$.ajax({
            type: 'POST',
            url: thisForm.attr("action"),
            data: thisForm.serialize(),
            success: function(data) {
             	$('#successMessage').show();
             	$('#closeBtn').show();
             	$('#submitBtn').hide();
            },
            error: function(data) {
             	$('#errorMessage').show();
             	$('#closeBtn').show();
             	$('#submitBtn').hide();
            }
         });
     });

});

</script>
{/literal}


