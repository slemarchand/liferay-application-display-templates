<#assign liferay_ui = taglibLiferayHash["/META-INF/liferay-ui.tld"] />
<#assign liferay_portlet = taglibLiferayHash["/META-INF/liferay-portlet-ext.tld"] />

<#if entries?has_content>
    <ul class="list-unstyled"> 
	<#list entries as curEntry>
	
	    <#assign viewURL = assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, curEntry, false) />

        <#assign editURL = curEntry.getAssetRenderer().getURLEdit(renderRequest, renderResponse).toString() />
        <#assign editURL = editURL?replace("p_p_state=normal", "p_p_state=pop_up") />
        <#assign editURL = editURL?replace("p_p_state=maximized", "p_p_state=pop_up") />

        <@liferay_portlet.actionURL var="deleteURL" 
            name="moveToTrash"
            portletName="com_liferay_journal_web_portlet_JournalPortlet"
        >
            <@liferay_portlet["param"] name="redirect" value=currentURL />
            <@liferay_portlet["param"] name="groupId" value=curEntry.getGroupId()?string />
            <@liferay_portlet["param"] name="articleId" value=curEntry.getAssetRenderer().getArticle().getArticleId() />
        </@liferay_portlet.actionURL>

	    <li class="h3 content">
		${curEntry.getTitle(locale)}
		<div class="pull-right"> 
		
		
		<#assign id = "my_custom_asset_publisher_viewAsset">
		<#assign data = { "destroyOnHide": true, "id": id, "title": "Edit" }>
        <@liferay_ui["icon"] 
            cssClass="icon-monospaced" 
            data=data
            icon="search" 
            label=false
			markupView="lexicon"
			message="View"
			method="get"
			url=viewURL
			useDialog=false
        />
        
		<#assign id = "my_custom_asset_publisher_editAsset">
		<#assign data = { "destroyOnHide": true, "id": id, "title": "Edit" }>
        <@liferay_ui["icon"] 
            cssClass="icon-monospaced" 
            data=data
            icon="pencil" 
            label=false
			markupView="lexicon"
			message="Edit"
			method="get"
			url=editURL
			useDialog=true
        />
        
        <@liferay_ui["icon-delete"] 
            cssClass="icon-monospaced" 
            trash=true
            icon="trash" 
			markupView="lexicon"
			url=deleteURL
        />
        </div>
		</li>
	</#list>
	</ul>
	
	<div class="button-holder dialog-footer" style="padding: 20px; margin: 0"> 
	    <button id="my_custom_addButton" class="btn btn-lg btn-primary btn-default" type="submit" > 
	    <span class="lfr-btn-label">Add</span> 
	    </button>
    </div>
    
<script>

$(function() {

	var customizeArticleEditor = function($body) {

		$body.find('.lfr-translation-manager').hide(); 

		$body.find('.input-localized-content').hide();
		
		$body.find('#_com_liferay_journal_web_portlet_JournalPortlet_indexable').closest('div').hide();

		$body.find('#structureAndTemplateHeader').hide();

		$body.find('#smallImageHeader').hide();

		$body.find('#metadataHeader').hide();		

		$body.find('#scheduleHeader').hide();	

		$body.find('#displayPageHeader').hide();	

		$body.find('#relatedAssetsHeader').click();	

		$body.find('#relatedAssetsHeader a').text("Related Contents");	

		$body.find('#permissionsHeader').hide();

		$body.find('li.asset-selector').each(function(){
			var $li = $(this);
			var $a = $li.find('a');

			var dataHref = $a.attr('data-href'); 
			console.log(dataHref);
			if(dataHref.indexOf('com.liferay.journal.model.JournalArticle') == -1) {
				$li.remove();
			} else if($a.attr('id').indexOf('basic-web-content') != -1){
				$li.remove();
			}
		});
	};
	
	$('#my_custom_addButton').on('click', function(e) {
		
		e.preventDefault();
		
		var $portlet = $(this).closest('.portlet-asset-publisher');
		$portlet.find('[data-qa-id=addButton] li a span').click();

		setTimeout(function() {
			var $iframe = $('iframe.dialog-iframe-node');
			$iframe.on('load', function() {
				customizeArticleEditor($iframe.contents().find('body'));
			});
		}, 100);	
	});

});
</script>

</#if>