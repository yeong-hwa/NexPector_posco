// JavaScript Document

var slideIndex = 0;

function prevSlides() {
	showSlides(-1);
}

function nextSlides() {
	showSlides(1);
}

function showSlides(cnt) {
	if(!cnt) {
		cnt = 0;
	}
	var slides = $(".pop_tbl_wrap");
	for (var i = 0; i < slides.length; i++) {
		slides[i].hide();
	}
	slides(slideIndex + cnt).show();
}