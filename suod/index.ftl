<#setting locale="ru_RU">
<#assign assetEntryLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetEntryLocalService")>
<#assign dlFileEntryLocalService = serviceLocator.findService("com.liferay.document.library.kernel.service.DLFileEntryLocalService")>
<#assign DDMStructureLocalService = serviceLocator.findService("com.liferay.dynamic.data.mapping.service.DDMStructureLocalService")>
<#assign assetVocabularyLocalServiceUtil = staticUtil["com.liferay.asset.kernel.service.AssetVocabularyLocalServiceUtil"]>
<#assign assetCategoryLocalServiceUtil = staticUtil["com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil"]>
<#assign userLocalServiceUtil = staticUtil["com.liferay.portal.kernel.service.UserLocalServiceUtil"]>

<#if !entries?has_content>
    <div class="alert alert-info text-center no-results-alert">
        Нет данных для отображения
    </div>
</#if>

<#if entries?has_content>
    <div class="row m-0">
        <#assign assetCategories = assetCategoryLocalServiceUtil.getVocabularyCategories(23803934, 0, 1000, comparator)>
        <#list assetCategories?sort_by("createDate") as category>
            <div class="category title-year position-relative mt-5 mb-3 col-12">
                <h4>${category.name}</h4>
            </div>
            <#list entries as entry>
                <#assign categories = entry.getCategories() />
                <#assign entryCategories = assetCategoryLocalServiceUtil.getCategories(entry.getClassName(), entry.getClassPK())>
                <#assign docXml = saxReaderUtil.read(entry.getAssetRenderer().getArticle().getContent()) />
                <#assign fieldValUserId = docXml.valueOf( "//dynamic-element[@name='author']/dynamic-content/text()") />

                <#assign user = userLocalServiceUtil.getUserById(fieldValUserId?number) />
                <#assign userEmail = user.getEmailAddress() />
                <#assign valuesMapExpando = user.getExpandoBridge().getAttributes() />
                <#assign jobUser = user.getJobTitle() />
                <#assign userSearchUrl = user.getDisplayURL(themeDisplay) />
                
                <#list entryCategories as entryCategory>
                    <#if category.name = entryCategory.name>
                        <div class="bg-light-blue p-3 col-12 mb-4">
                            <div class="row">
                                <div class="col-2">
                                    <div class="publications-cards__image">
                                        <@liferay_ui["user-portrait"]
                                                userId=fieldValUserId?number
                                        />
                                    </div>
                                </div>
                                <div class="col-5">
                                    <div class="publications-cards__author text-info">
                                        <h6 class="mb-2">
                                            <a href="${userSearchUrl}" target="_blank">${user.getFullName()}</a>
                                        </h6>
                                    </div>
                                    <div class="publications-cards__jobUser">
                                        <#if jobUser?has_content>
                                            <p class="mb-2">${jobUser}</p>
                                        <#else>
                                            <p>Пользователь</p>
                                        </#if>
                                    </div>
                                    <#assign organizations = user.getOrganizations()>
                                    <#if organizations?has_content>
                                        <#assign userOrg = organizations[0]>
                                        <#assign valuesMapExpandoUserOrg = userOrg.getExpandoBridge().getAttributes() />
                                        <#if valuesMapExpandoUserOrg["name"]?has_content >
                                            <#assign orgNames = valuesMapExpandoUserOrg["ru.emdev.ekp.corporate.search.integration.namePath"] />
                                            <div class="user-card__organization mb-3">
                                                <#if orgNames?is_sequence>
                                                    <#list orgNames as orgName>
                                                        <#if orgName?is_first>
                                                                <a href="http://portal-aero.gazprom-neft.local/HR/Pages/rewardresult.aspx#" target="_blank">${htmlUtil.escape(orgName)}</a>
                                                        </#if>
                                                    </#list>
                                                </#if>
                                            </div>
                                        </#if>
                                    </#if>
                                </div>
                                <div class="col-5">
                                    <div class="publications-cards__phone">
                                        <#if valuesMapExpando["ru.emdev.ekp.corporate.search.integration.telOffice"]?has_content >
                                            <#assign telOffice = valuesMapExpando["ru.emdev.ekp.corporate.search.integration.telOffice"] />
                                            <b><span class="d-block">${htmlUtil.escape(telOffice)}</span></b>
                                        </#if>
                                        <#if valuesMapExpando["ru.emdev.ekp.corporate.search.integration.telInternal"]?has_content >
                                            <#assign telInternal = valuesMapExpando["ru.emdev.ekp.corporate.search.integration.telInternal"] />
                                            <b><span class="d-block">${htmlUtil.escape(telInternal)}</span></b>
                                        </#if>
                                        <#if valuesMapExpando["ru.emdev.ekp.corporate.search.integration.telMobile"]?has_content >
                                            <#assign telMobile = valuesMapExpando["ru.emdev.ekp.corporate.search.integration.telMobile"] />
                                            <b><span class="d-block">${htmlUtil.escape(telMobile)}</span></b>
                                        </#if>
                                    </div>
                                    <div class="content-email mb-2">
                                        <#if userEmail?has_content>
                                            <a class="publications-cards__email" href='mailto:${userEmail}' target="_blank">${userEmail}</a>
                                        <#else>
                                            Email
                                        </#if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </#if>
                </#list>
            </#list>
        </#list>
    </div>
</#if>



<style>
    .contacts-item .rounded-circle.sticker.sticker-primary img,
    .contacts-item .publications-cards__image .sticker{
        width: 100%;
        height: auto!important;
    }

    .rounded-circle.sticker.sticker-primary img,
    .publications-cards__image .sticker{
        width: 150px;
        height: 150px!important;
        object-fit: cover;
    }
    
    .contacts-item .sticker.rounded-circle .sticker-overlay, 
    .contacts-item .sticker.img-circle .sticker-overlay, 
    .contacts-item .publications-cards__image .sticker-circle{
        border-radius: 5000px!important;
    }

    .portlet-body .bg-light-blue{
        border-radius: 8px;
    }

    .sticker.rounded-circle .sticker-overlay, 
    .sticker.img-circle .sticker-overlay, 
    .publications-cards__image .sticker-circle{
        border-radius: 5px!important;
    }
    
    .publications-cards__image .lexicon-icon{
        width: 100px;
        height: 100px;
    }
</style>