<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@ page import="org.akaza.openclinica.i18n.util.ResourceBundleProvider" %>
<%@ page import="java.net.URLDecoder" %>

<fmt:setBundle basename="org.akaza.openclinica.i18n.workflow" var="resworkflow"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>

<script language="JavaScript">

        // Walkme snippet
        (function() {
            var walkme = document.createElement('script');
            walkme.type = 'text/javascript';
            walkme.async = true;
            walkme.src = '<c:out value="${sessionScope.walkmeURL}" />';
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(walkme, s);
            window._walkmeConfig = {
                smartLoad: true
            };
        })();

        function confirmCancel(pageName){
            var confirm1 = confirm('<fmt:message key="sure_to_cancel" bundle="${resword}"/>');
            if(confirm1){
                window.location = pageName;
            }
        }
        function confirmExit(pageName){
            var confirm1 = confirm('<fmt:message key="sure_to_exit" bundle="${resword}"/>');
            if(confirm1){
                window.location = pageName;
            }
        }
        function goBack(){
            var confirm1 = confirm('<fmt:message key="sure_to_cancel" bundle="${resword}"/>');
            if(confirm1){
                return history.go(-1);
            }
        }
        function lockedCRFAlert(userName){
            alert('<fmt:message key="CRF_unavailable" bundle="${resword}"/>'+'\n'
                    +'          '+userName+' '+'<fmt:message key="Currently_entering_data" bundle="${resword}"/>'+'\n'
                    +'<fmt:message key="Leave_the_CRF" bundle="${resword}"/>');
            return false;
        }
        function confirmCancelAction( pageName, contextPath){
            var confirm1 = confirm('<fmt:message key="sure_to_cancel" bundle="${resword}"/>');
            if(confirm1){
                 var tform = document.forms["fr_cancel_button"];
                tform.action=contextPath+"/"+pageName;
                tform.submit();

            }
        }
        function confirmExitAction( pageName, contextPath){
            var confirm1 = confirm('<fmt:message key="sure_to_exit" bundle="${resword}"/>');
            if(confirm1){
                 var tform = document.forms["fr_cancel_button"];
                tform.action=contextPath+"/"+pageName;
                tform.submit();

            }
        }
        function createReturnToCookie (returnTo) {
            var date = new Date();
            date.setTime(date.getTime()+(30*1000));
            var expires = "; expires="+date.toGMTString();
            document.cookie = "returnTo=" + encodeURIComponent(returnTo) + expires + "; path=/";
        }
</script>


<jsp:useBean scope='session' id='tableFacadeRestore' class='java.lang.String' />
<c:set var="restore" value="true"/>
<c:if test="${tableFacadeRestore=='false'}"><c:set var="restore" value="false"/></c:if>
<c:set var="profilePage" value="${param.profilePage}"/>
<!--  If Controller Spring based append ../ to urls -->
<c:set var="urlPrefix" value=""/>
<c:set var="requestFromSpringController" value="${param.isSpringController}" />
<c:if test="${requestFromSpringController == 'true' }">
      <c:set var="urlPrefix" value="${pageContext.request.contextPath}/"/>
</c:if>

<!-- Main Navigation -->
    <link rel="stylesheet" href="includes/css/icomoon-style.css">
     <div class="oc_nav">
        <div class="nav-top-bar">
        <!-- Logo -->

            <div class="logo">
                <c:set var="isLogo"/>
                <c:set var="isHref"/>

                <c:if test="${param.isSpringController}">
                    <c:set var="isHref" value="../MainMenu" />
                    <c:set var="isLogo" value="../images/logo-color-on-dark.svg" />
                </c:if>

                <c:if test="${!param.isSpringController}">
                    <c:set var="isHref" value="MainMenu" />
                    <c:set var="isLogo" value="images/logo-color-on-dark.svg" />
                </c:if>

                <a href="${isHref}"><img src="${isLogo}" alt="OpenClinica Logo" /></a>
            </div>

            <div id="StudyInfo">
                <c:choose>
                    <c:when test='${study.parentStudyId > 0}'>
                        <b><a href="${urlPrefix}ViewStudy?id=${study.parentStudyId}&viewFull=yes"
                            title="<c:out value='${study.parentStudyName}'/>"
                            alt="<c:out value='${study.parentStudyName}'/>" ><c:out value="${study.abbreviatedParentStudyName}" /></a>
                            :&nbsp;<a href="${urlPrefix}ViewSite?id=${study.id}" title="<c:out value='${study.name}'/>" alt="<c:out value='${study.name}'/>"><c:out value="${study.abbreviatedName}" /></a></b>
                    </c:when>
                    <c:otherwise>
                        <b><a href="${urlPrefix}ViewStudy?id=${study.id}&viewFull=yes" title="<c:out value='${study.name}'/>" alt="<c:out value='${study.name}'/>"><c:out value="${study.abbreviatedName}" /></a></b>
                    </c:otherwise>
                </c:choose>
                (<c:out value="${study.abbreviatedIdentifier}" />)&nbsp;&nbsp;<span class="stat-tag status-${fn:toLowerCase(study.envType)}"></span>&nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="${urlPrefix}ChangeStudy">Change</a>

            </div>

            <%
                String currentURL = null;
                if( request.getAttribute("javax.servlet.forward.request_uri") != null ){
                    currentURL = (String)request.getAttribute("javax.servlet.forward.request_uri");
                }
                if( currentURL != null && request.getQueryString() != null ){
                    currentURL += "?" + request.getQueryString();
                }
            %>
            <div id="UserInfo">
                <div id="userDropdown">
                    <ul>
                        <li><a href="#"><b><c:out value="${userBean.name}" /></b> (<c:out value="${userRole.role.description}" />)<span class="icon icon-caret-down white"></span></a></a>
                        <!-- First Tier Drop Down -->
                        <ul class="dropdown_BG">
                            <li><a href="${study.manager}"><fmt:message key="return_to_my_studies" bundle="${resworkflow}"/></a></li>
                            <li><a href="javascript:openDocWindow('<c:out value="${sessionScope.supportURL}" />')"><fmt:message key="openclinica_feedback" bundle="${resword}"/></a></li>
                            <li> <a onClick="javascript:createReturnToCookie('<%=currentURL%>');" href="${urlPrefix}pages/logout"><fmt:message key="log_out" bundle="${resword}"/></a></li>
                        </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

         <div class="box_T"><div class="box_L"><div class="box_R"><div class="box_B"><div class="box_TL"><div class="box_TR"><div class="box_BL"><div class="box_BR">

            <div class="navbox_center">
                <!-- Top Navigation Row -->
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <div id="bt_Home" class="nav_bt"><div><div><div>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td>
                                      <form METHOD="GET" action="ListStudySubjects" onSubmit=" if (document.forms[0]['findSubjects_f_studySubject.label'].value == '<fmt:message key="study_subject_ID" bundle="${resword}"/>') { document.forms[0]['findSubjects_f_studySubject.label'].value=''}">
                                                                    <!--<a href="javascript:reportBug()">Report Issue</a>|-->
                                            <input type="text" name="findSubjects_f_studySubject.label" onblur="if (this.value == '') this.value = '<fmt:message key="study_subject_ID" bundle="${resword}"/>'" onfocus="if (this.value == '<fmt:message key="study_subject_ID" bundle="${resword}"/>') this.value = ''" value='<fmt:message key="study_subject_ID" bundle="${resword}"/>' class="navSearch"/>
                                            <input type="hidden" name="navBar" value="yes"/>
                                            <input type="submit" value="View &#8594;"  class="navSearchButton"/>
                                        </form>
                                    </td>
                                    <td align="right" style="font-weight: normal;">
                                    <ul>
                                        <c:if test="${userRole.coordinator || userRole.director}">
                                            <li><a href="${urlPrefix}MainMenu"><fmt:message key="nav_home" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}StudyAuditLog"><fmt:message key="nav_study_audit_log" bundle="${resword}"/></a></li>
                                        </c:if>
                                        <c:if test="${userRole.researchAssistant ||userRole.researchAssistant2}">
                                            <li><a href="${urlPrefix}MainMenu"><fmt:message key="nav_home" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></li>
                                            <c:if test="${study.status.available}">
                                                <li><a href="${urlPrefix}AddNewSubject"><fmt:message key="nav_add_subject" bundle="${resword}"/></a></li>
                                            </c:if>
                                            <li><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></li>
                                        </c:if>
                                        <c:if test="${userRole.investigator}">
                                            <li><a href="${urlPrefix}MainMenu"><fmt:message key="nav_home" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></li>
                                            <c:if test="${study.status.available}">
                                                <li><a href="${urlPrefix}AddNewSubject"><fmt:message key="nav_add_subject" bundle="${resword}"/></a></li>
                                            </c:if>
                                            <li><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></li>
                                        </c:if>
                                        <c:if test="${userRole.monitor }">
                                            <li><a href="${urlPrefix}MainMenu"><fmt:message key="nav_home" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}pages/viewAllSubjectSDVtmp?sdv_restore=${restore}&studyId=${study.id}"><fmt:message key="nav_sdv" bundle="${resword}"/></a></li>
                                            <li><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></li>
                                        </c:if>
                                        <li id="nav_Tasks" style="position: relative; z-index: 3;">
                                            <a href="#" onmouseover="setNav('nav_Tasks');" id="nav_Tasks_link"><fmt:message key="nav_tasks" bundle="${resword}"/>
                                               <span class="icon icon-caret-down white"></span></a>
                                        </li>
                                        </ul>
                                    </td>
                                </tr>
                            </table>
                            </div></div></div></div>
                        </td>
                    </tr>
                </table>
            </div>
            <!-- End shaded box border DIVs -->
        </div></div></div></div></div></div></div></div></div>


            </td>
        </tr>
    </table>
    <!-- NAVIGATION DROP-DOWN -->



<div id="nav_hide" style="position: absolute; left: 0px; top: 0px; visibility: hidden; z-index: 2; width: 100%; height: 400px;">

<a href="#" onmouseover="hideSubnavs();"><img src="http://dev40.openclinica.info:8080/OpenClinica/images/spacer.gif" alt="" width="1000" height="400" border="0"/></a>
</div>


    </div>
    <img src="${urlPrefix}images/spacer.gif" width="596" height="1"><br>
<!-- End Main Navigation -->
<div id="subnav_Tasks" class="dropdown">
    <div class="dropdown_BG">
        <c:if test="${userRole.monitor }">
        <div class="taskGroup"><fmt:message key="nav_monitor_and_manage_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></div>
            <div class="taskLink"><a href="${urlPrefix}ViewStudyEvents"><fmt:message key="nav_view_events" bundle="${resword}"/></a></div>
            <div class="taskLink"><a href="${urlPrefix}pages/viewAllSubjectSDVtmp?sdv_restore=${restore}&studyId=${study.id}"><fmt:message key="nav_source_data_verification" bundle="${resword}"/></a></div>
        </div>
        <div class="taskRightColumn">
            <div class="taskLink"><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></div>
            <div class="taskLink"><a href="${urlPrefix}StudyAuditLog"><fmt:message key="nav_study_audit_log" bundle="${resword}"/></a></div>
        </div>
        <br clear="all">
        <div class="taskGroup"><fmt:message key="nav_extract_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}ViewDatasets"><fmt:message key="nav_view_datasets" bundle="${resword}"/></a></div>
        </div>
        <div class="taskRightColumn">
            <div class="taskLink"><a href="${urlPrefix}CreateDataset"><fmt:message key="nav_create_dataset" bundle="${resword}"/></a></div>
        </div>
        <br clear="all">
        </c:if>
        <c:if test="${userRole.researchAssistant ||userRole.researchAssistant2  }">
        <div class="taskGroup"><fmt:message key="nav_submit_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></div>
            <c:if test="${study.status.available}">
                <div class="taskLink"><a href="${urlPrefix}AddNewSubject"><fmt:message key="nav_add_subject" bundle="${resword}"/></a></div>
            </c:if>
            <div class="taskLink"><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></div>
        </div>
        <div class="taskRightColumn">
            <c:if test="${!study.status.frozen && !study.status.locked}">
                <div class="taskLink"><a href="${urlPrefix}CreateNewStudyEvent"><fmt:message key="nav_schedule_event" bundle="${resword}"/></a></div>
            </c:if>
            <div class="taskLink"><a href="${urlPrefix}ViewStudyEvents"><fmt:message key="nav_view_events" bundle="${resword}"/></a></div>
            <div class="taskLink"><a href="${urlPrefix}ImportCRFData"><fmt:message key="nav_import_data" bundle="${resword}"/></a></div>
        </div>
        <br clear="all">
        </c:if>
        <c:if test="${userRole.investigator}">
        <div class="taskGroup"><fmt:message key="nav_submit_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></div>
            <c:if test="${study.status.available}">
                <div class="taskLink"><a href="${urlPrefix}AddNewSubject"><fmt:message key="nav_add_subject" bundle="${resword}"/></a></div>
            </c:if>
            <div class="taskLink"><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></div>
        </div>
        <div class="taskRightColumn">
            <c:if test="${!study.status.frozen && !study.status.locked}">
                <div class="taskLink"><a href="${urlPrefix}CreateNewStudyEvent"><fmt:message key="nav_schedule_event" bundle="${resword}"/></a></div>
            </c:if>
            <div class="taskLink"><a href="${urlPrefix}ViewStudyEvents"><fmt:message key="nav_view_events" bundle="${resword}"/></a></div>
            <div class="taskLink"><a href="${urlPrefix}ImportCRFData"><fmt:message key="nav_import_data" bundle="${resword}"/></a></div>
        </div>
        <br clear="all">
        <div class="taskGroup"><fmt:message key="nav_extract_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}ViewDatasets"><fmt:message key="nav_view_datasets" bundle="${resword}"/></a></div>
        </div>
        <div class="taskRightColumn">
            <div class="taskLink"><a href="${urlPrefix}CreateDataset"><fmt:message key="nav_create_dataset" bundle="${resword}"/></a></div>
        </div>
        <br clear="all">
        </c:if>
        <c:if test="${userRole.coordinator || userRole.director}">
        <div class="taskGroup"><fmt:message key="nav_submit_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}ListStudySubjects"><fmt:message key="nav_subject_matrix" bundle="${resword}"/></a></div>
            <c:if test="${study.status.available}">
                <div class="taskLink"><a href="${urlPrefix}AddNewSubject"><fmt:message key="nav_add_subject" bundle="${resword}"/></a></div>
            </c:if>
            <div class="taskLink"><a href="${urlPrefix}ViewNotes?module=submit"><fmt:message key="queries" bundle="${resword}"/></a></div>
        </div>
        <div class="taskRightColumn">
            <c:if test="${!study.status.frozen && !study.status.locked}">
                <div class="taskLink"><a href="${urlPrefix}CreateNewStudyEvent"><fmt:message key="nav_schedule_event" bundle="${resword}"/></a></div>
            </c:if>
            <div class="taskLink"><a href="${urlPrefix}ViewStudyEvents"><fmt:message key="nav_view_events" bundle="${resword}"/></a></div>
            <div class="taskLink"><a href="${urlPrefix}ImportCRFData"><fmt:message key="nav_import_data" bundle="${resword}"/></a></div>
        </div>
        <br clear="all">
        <div class="taskGroup"><fmt:message key="nav_monitor_and_manage_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}StudyAuditLog"><fmt:message key="nav_study_audit_log" bundle="${resword}"/></a></div>
            <div class="taskLink"><a href="${urlPrefix}ViewRuleAssignment?read=true"><fmt:message key="nav_rules" bundle="${resword}"/></a>
            </div>
            <c:choose>
                <c:when test="${study.parentStudyId > 0 && (userRole.coordinator || userRole.director) }">
                </c:when>
                <c:otherwise>
                    <div class="taskLink"><a href="${urlPrefix}ViewStudy?id=${study.id}&viewFull=yes"><fmt:message key="nav_view_study" bundle="${resword}"/></a></div><div class="taskLink"></div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="taskRightColumn">
        <c:choose>
            <c:when test="${study.parentStudyId > 0 && (userRole.coordinator || userRole.director) }">
            </c:when>
            <c:otherwise>
                <div class="taskLink"><a href="${urlPrefix}ListSite?read=true"><fmt:message key="nav_sites" bundle="${resword}"/></a></div>
                <div class="taskLink"><a href="${urlPrefix}ListCRF?module=manage"><fmt:message key="nav_crfs" bundle="${resword}"/></a></div><div class="taskLink"><br/></div>
            </c:otherwise>
        </c:choose>
        </div>
        <br clear="all">
        <div class="taskGroup"><fmt:message key="nav_extract_data" bundle="${resword}"/></div>
        <div class="taskLeftColumn">
            <div class="taskLink"><a href="${urlPrefix}CreateDataset"><fmt:message key="nav_create_dataset" bundle="${resword}"/></a></div>
        </div>
        <div class="taskRightColumn">
            <div class="taskLink"><a href="${urlPrefix}ViewDatasets"><fmt:message key="nav_view_datasets" bundle="${resword}"/></a></div>
        </div>
        <br clear="all">
        </c:if>
    </div>
</div>
