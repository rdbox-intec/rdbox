#!/usr/bin/env python3
from flask import request, Response
from flask_rdbox import app
import os
import subprocess
import pexpect
import time
import json


class GCloudSetupper(object):
    __singleton = None
    pex = None
    retURL = {
        'url': '',
        'date': int(time.time())
    }

    def __new__(cls, *args, **kwargs):
        if cls.__singleton is None:
            cls.__singleton = super(GCloudSetupper, cls).__new__(cls)
        return cls.__singleton

    def __init__(self):
        super().__init__()

    def getURL(self):
        if self.pex is not None:
            self.pex.sendcontrol('c')
        self.pex = pexpect.spawn('/usr/bin/gcloud auth login')
        self.pex.expect('https://accounts.google.com/*')
        self.pex.expect('Enter verification code:')
        url = 'https://accounts.google.com/' + self.pex.before.decode('utf-8')
        url = url.strip()
        self.retURL = {
            'url': url,
            'date': str(int(time.time()))
        }
        return self.retURL

    def setToken(self, token, date):
        if self.retURL['date'] == date:
            self.pex.sendline(token)
            try:
                self.pex.expect('You are now logged in as')
            except pexpect.TIMEOUT:
                return 408, 'Failed to communicate with cloud servers. ' \
                            'Give it some time and then run it again. '
            except pexpect.EOF:
                return 403, 'Failed to authenticate the verification code. ' \
                            'Please re-enter the correct code. '
            else:
                return 200, 'OK'
        else:
            return 400, 'The sessions are different. ' \
                        'Reload the window and perform ' \
                        'the operation again from the beginning. '
