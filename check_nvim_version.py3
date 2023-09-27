#!/usr/bin/python3
import subprocess, os
from bs4 import BeautifulSoup
# https://stackoverflow.com/questions/53911695/scrape-urls-using-beautifulsoup-in-python-3
from urllib.request import Request, urlopen


def get_nvim_desktop_version():
    # https://docs.python.org/3/library/subprocess.html#subprocess.check_output
    # returns a bytes like object
    nvim_version_desktop = subprocess.check_output(["nvim", "--version"])
    # https://sparkbyexamples.com/python/python-convert-bytes-to-string/
    nvim_version_desktop_str = nvim_version_desktop.decode('utf-8')
    # https://stackoverflow.com/questions/11833266/how-do-i-read-the-first-line-of-a-string
    return nvim_version_desktop_str.partition('\n')[0]


def get_nvim_latest_version():

    req = Request('https://github.com/neovim/neovim/releases/latest')
    neovim_latest_html = urlopen(req).read()
    soup = BeautifulSoup(neovim_latest_html, 'html.parser')
    # https://www.educative.io/answers/web-scraping-with-beautiful-soup
    xwe = soup.find("div", class_="snippet-clipboard-content notranslate position-relative overflow-auto").code
    # https://stackoverflow.com/questions/37860039/print-specific-line-beautifulsoup
    li = xwe.prettify().split('\n')
    # https://stackoverflow.com/questions/959215/how-do-i-remove-leading-whitespace-in-python
    return li[1].lstrip() 


nvim_desktop_version = get_nvim_desktop_version()
nvim_latest_version = get_nvim_latest_version()

if (nvim_desktop_version == nvim_latest_version):
    print("desktop version is up-to-date")
else:
    print("desktop version is out-of-date")
    subprocess.run(["wget", "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"])
    # using popen for shell command with pipes: https://stackoverflow.com/questions/13332268/how-to-use-subprocess-command-with-pipes
    # if you're curious about the subprocess.PIPE thing: https://stackoverflow.com/questions/19961052/what-is-the-difference-if-i-dont-use-stdout-subprocess-pipe-in-subprocess-popen
    nvim_ps = subprocess.Popen("whereis nvim | cut -d ':' -f 2", stdout=subprocess.PIPE, shell=True, text=True)
    nvim_abs_path = nvim_ps.communicate()[0]
    os.system("mv nvim.appimage " + nvim_abs_path)
    os.system("chmod u+x " + nvim_abs_path)

