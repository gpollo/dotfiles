#!/usr/bin/env python2
#
# Usage: <executable> <link>
#
# Note: You need to setup your login informations. You can customize the
#       informations that is fill in the download form below.

import re
import os
import sys
import mechanize
import urllib2
import cookielib
import requests
import codecs
import configparser
from bs4 import BeautifulSoup

# read configuration files
configfile = os.path.expanduser("~") + "/.config/xget.conf"
config = configparser.ConfigParser()
config.sections()
config.readfp(codecs.open(configfile, "r", "utf8"))

# some constants
website="https://www.xilinx.com"
login_url=website+"/registration/sign-in.html"
login_form="_content_xilinx_en_registration_login_jcr_content_mainParsys_start_af80"
export_form="_content_xilinx_en_member_forms_download_dlc_jcr_content_mainParsys_start_7e05"

def login(browser):
    # navigate to the login page
    browser.open(login_url)

    # fill out the form
    browser.select_form(name=login_form)
    browser.form['user'] = config['login']['username'].encode('ascii')
    browser.form['password'] = config['login']['password'].encode('ascii')
    browser.submit()

def download(target, browser):
    # navigate to the file's link
    browser.open(website+target.get_url())

    # fill out the form
    browser.select_form(name=export_form)
    browser.form.set_all_readonly(False) 
    browser.form['First_Name']   =  config['download']['first_name']
    browser.form['Last_Name']    =  config['download']['last_name']
    browser.form['Email']        =  config['download']['email']
    browser.form['Company']      =  config['download']['company']
    browser.form['Address_1']    =  config['download']['address_1']
    browser.form['Address_2']    =  config['download']['address_2']
    browser.form['City']         =  config['download']['city']
    browser.form['State']        =  config['download']['state']
    browser.form['Country']      = [config['download']['country']]
    browser.form['Zip_Code']     =  config['download']['zip_code']
    browser.form['Job_Function'] = [config['download']['job']]
    browser.form['Industry']     = [config['download']['industry']]
    response = browser.submit()

    # download the file
    fd = open(target.get_filename(), "wb")
    stream = requests.get(response.geturl(), stream=True)
    size = int(stream.headers['Content-length'])
    current = 0

    for chunk in stream.iter_content(chunk_size=65536):
        # write progress
        current = current+65536
        percent = int((float(current)/float(size))*100)
        filename = target.get_filename()
        sys.stdout.write("\rDownloading '{}' {}%".format(filename, percent))

        # write chunk
        if chunk:
            fd.write(chunk)

    # cleanup
    sys.stdout.write("\rDownloading '{}' 100%\n".format(filename))
    fd.close()

regex = r"\=\w.*\&"
def get_filename(link):
    return re.findall(regex, link)[0][1:-1]

def get_size(html):
    pass

class target(object):
    def __init__(self, url, filename, present=False):
        self.__url      = url
        self.__filename = filename
        self.__present  = present

    def get_url(self):
        return self.__url

    def get_filename(self):
        return self.__filename

    def is_present(self):
        return self.__present

if __name__ == '__main__':
    # make sure the user specified the URL
    if len(sys.argv) < 2:
        print("Please specify the files location.")
        exit(1)
        
    # browser settings
    cookies = cookielib.CookieJar()
    browser = mechanize.Browser()
    browser.set_cookiejar(cookies)
    browser.set_handle_robots(False)
    browser.set_handle_redirect(True)

    # navigate to the download link
    page = browser.open(sys.argv[1])
    html = BeautifulSoup(page.read(), "lxml")
    links = html.findAll('li', class_='download-links')

    downloads = []

    # get all download links
    print("     On disk\t Filename")
    for link in links:
        url = link.find('a')['href']
        filename = get_filename(url)
        present = os.path.isfile(filename)
        size = link.findAll('span', class_='subdued')[0].text.strip()

        print("[{:>2}] {}\t {} {}".format(len(downloads), present, filename, size))
        downloads.append(target(url, filename, present))

    # get user's choices
    choices = raw_input("Enter the file to download (#,#,...): ").strip().split(',')
    choices = dict.fromkeys(choices).keys()

    for choice in choices:
        # remove empty selection
        if choice == '':
            continue

        # remove non-numeric selection
        if not choice.isdigit():
            print("Invalid selection '{}'".format(choice))
            continue

        # remove invalid selection
        choice = int(choice)
        if choice >= len(downloads):
            print("Invalid selection '{}'".format(choice))
            continue

        # download the files
        login(browser)
        download(downloads[choice], browser)
