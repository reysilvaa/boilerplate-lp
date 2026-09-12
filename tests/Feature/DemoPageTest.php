<?php

use Inertia\Testing\AssertableInertia as Assert;

test('root renders the cycle10 landing page', function () {
    $this->get('/')->assertInertia(fn (Assert $page) => $page
        ->component('cycle10/LandingPage')
        ->where('name', 'Kelas TOEFL Skor 500+ untuk Submission Beasiswa dan Kerja'));
});

test('c10-lp renders the cycle10 landing page identically to root', function () {
    $this->get('/c10-lp')->assertInertia(fn (Assert $page) => $page
        ->component('cycle10/LandingPage')
        ->where('name', 'Kelas TOEFL Skor 500+ untuk Submission Beasiswa dan Kerja'));
});
