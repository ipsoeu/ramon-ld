$(document).ready(function() {
// Header      
  $("header").addClass("hide");
// Navbar        
//  $("nav").append('<p><a href="../../..">Linked NUTS</a></p><ul id="actions"><li id="geoiri-edit"><a href="#" title="Edit geometry">Geometry</a></li><li id="format-list"><a href="#" title="Available formats">Formats</a></li></ul><ul id="info"><li id="about"><a href="#">About</a></li></ul>');
  $("nav").addClass("navbar navbar-default navbar-fixed-top container-fluid");
  $("nav > p").addClass("navbar-header");
  $("nav > p > a").addClass("navbar-brand");
  $("nav > ul").addClass("nav navbar-nav collapse navbar-collapse");
  $("nav > ul li > ul").addClass("dropdown-menu");
  $("nav > ul li > ul").attr("role", "menu");
  $("nav > ul li > ul").parent().addClass("dropdown dropdown-header");
  $("#dataset-section, #dataset-item-section").addClass("bs-docs-section container clearfix");
  $("#dataset-section > p, #dataset-item-section > p").addClass("bd-callout bd-callout-info");
  $("section dl").addClass("dl-horizontal");
//  $("footer").addClass("bs-docs-footer");
  $("footer").addClass("page-footer");
//  $("footer > #licence").addClass("footer-copyright text-center");
  $("table").addClass("table table-striped table-hover");
// "Geometry" button        
  $("#geoiri-edit").attr('data-toggle','modal').attr('data-target','#geoiri-section');
  $("#geoiri-edit a, #geoiri-section h4").addClass("edit");
// "Formats" button        
  $("#format-list").attr('data-toggle','modal').attr('data-target','#format-list-section');
  $("#format-list a, #format-list-section h4").addClass("get");
  if ($('#format-list-section a').length === 0) {
    $('#format-list').addClass('disabled').removeAttr('data-target');
    $('#format-list a').attr('title','None available yet');
  }
// "About" button
  $("#info").addClass("nav navbar-nav navbar-right");
//        $("#info").addClass("nav navbar-nav navbar-left");
  $("#about").attr('data-toggle','modal').attr('data-target','#about-section');
  $("#about a, #about-section h4").addClass("about");
//  $("#licence").addClass("alert alert-info");
  $("#licence").addClass("bs-callout bs-callout-info");
// Sections        
  $('#geometry-wkt-box').addClass('modal-body');
  $('#format-list-section > div, #about-section > div').addClass('modal-body');
  $('#srid-box, #getgeoiri').wrapAll('<div class="form-inline modal-footer"></div>');
  $('#srid-box').addClass('input-group').css("float","left");
  $('#geoiri-section > *').wrapAll('<div class="modal-dialog"><div class="modal-content"></div></div>');
  $('#format-list-section > *').wrapAll('<div class="modal-dialog"><div class="modal-content"></div></div>');
  $('#about-section > *').wrapAll('<div class="modal-dialog"><div class="modal-content"></div></div>');
  $('#geoiri-section h4, #format-list-section h4, #about-section h4').wrap('<div class="modal-header"></div>');

  $('#geoiri-section, #format-list-section, #about-section').addClass('modal fade').attr('role','dialog');
//        $('#geoiri-section > div').addClass('modal-dialog');
//        $('#geoiri-section > div > div').addClass('modal-content');
  $('#format-list-section .modal-content, #about-section .modal-content').append('<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');        
//  $('#format-list-section .modal-content, #geoiri-section .modal-content, #about-section .modal-content').append('<div class="modal-footer"><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div>');        
  
  $('.modal-header').prepend('<button type="button" class="close" data-dismiss="modal">&#xd7;</button>');
  $('.modal-header h4').addClass('modal-title');
// Formats section        
  $('#format-list-section a').addClass('get');
  $('#format-list-section .modal-body').addClass('container-fluid');
  $('#format-list-rdf, #format-list-others').addClass('col-md-6 list-group');
  $('#format-list-section .list-group > a').addClass('list-group-item');
//        $('#format-list-section .modal-body ul > li > a').addClass('btn btn-block').css("text-align","left");
//        $("nav > form").addClass("navbar-form navbar-left");
//        $("nav > form > div").addClass("form-group input-group");
//        $("footer > ul").addClass("nav navbar-nav collapse navbar-collapse");
//        $("footer > ul li > ul").addClass("dropdown-menu");
//        $("footer > ul li > ul").attr("role", "menu");
//        $("footer > ul li > ul").parent().addClass("dropdown dropdown-header");
//        $(".dropdown > a").addClass("dropdown-toggle").attr('data-toggle','dropdown').attr('aria-expanded','false').append('&#xa0;<span class="caret"></span>');
//        $('#geoiri-section').addClass('modal fade').attr('role','dialog');
  $("label").addClass("control-label");
  $("label[for=srid]").addClass("input-group-addon");
  $("input[type=text], input[type=number]").addClass("form-control");
  $("textarea").addClass("form-control");
  $("input[type=submit]").addClass("btn btn-primary");
  $("#srid").css("width","7em");
  $("#geometry-wkt").attr("aria-describedby","geometry-wkt-help");
//        $('#about-section').addClass('modal fade').attr('role','dialog');
  $('.about').prepend($('<i></i>').addClass('glyphicon glyphicon-question-sign').append('&#xa0;'));
//  $('.edit').prepend($('<i></i>').addClass('glyphicon glyphicon-edit').append('&#xa0;'));
  $('.edit').prepend($('<i></i>').addClass('glyphicon glyphicon-map-marker').append('&#xa0;'));
  $('.get').prepend($('<i></i>').addClass('glyphicon glyphicon-save').append('&#xa0;'));
  $('.help').addClass('help-block');
  $('.info').prepend($('<i></i>').addClass('glyphicon glyphicon-info-sign'));
// Map        
  $('#map').css('position', 'absolute').css('top', $('nav').outerHeight()).css('overflow', 'hidden');
  $('#map').css('width', $(window).width()).css('height', $(window).height() - $('nav').outerHeight() - $('footer').height());
  if (typeof featurecollection === 'undefined') {
    $('#geoiri-section').modal('show');
  }
// Showing the page        
  $("html").css("visibility","visible");
} );

