from powerline_shell.utils import BasicSegment
import os
import json

class Segment(BasicSegment):
  def add_to_powerline(self):
    with open('/root/.bluemix/.cf/config.json') as json_file:
      config = json.load(json_file)
      try:
        self.powerline.append(" o:%s " % config['OrganizationFields']['Name'],
          self.powerline.theme.IBMCLOUD_ORG_FG,
          self.powerline.theme.IBMCLOUD_ORG_BG)
      except:
        pass
