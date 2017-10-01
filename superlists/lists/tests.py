from django.core.urlresolvers import resolve
from django.test import TestCase
from django.http import HttpRequest
from .views import home_page
from django.template.loader import render_to_string


class HomePageTest(TestCase):

    @classmethod
    def setUpClass(cls):
        import os
        os.environ["DJANGO_SETTINGS_MODULE"] = "superlists.settings"
        super(HomePageTest, cls).setUpClass()

    def setUp(self):
        super(HomePageTest, self).setUp()
        self.request = HttpRequest()
    
    def test_root_url_resolves_to_home_page(self):
        found = resolve('/')
        self.assertEqual(found.func, home_page)

    def test_home_page_returns_correct_html(self):
        response = home_page(self.request)
        expected_html = render_to_string('home.html')
        self.assertEqual(response.content.decode(), expected_html)

