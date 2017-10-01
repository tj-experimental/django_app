from __future__ import unicode_literals

import logging
from django.shortcuts import render

log = logging.getLogger(__name__)

def home_page(request):
    return render(request, 'home.html')
