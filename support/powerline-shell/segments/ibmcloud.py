from powerline_shell.utils import BasicSegment
import os
import json

class Segment(BasicSegment):
  def add_to_powerline(self):
    self.powerline.append(" bxshell(%s) " % os.environ['BXSHELL_TARGET'],
      self.powerline.theme.IBMCLOUD_ENV_FG,
      self.powerline.theme.IBMCLOUD_ENV_BG)
    
    with open('/root/.bluemix/config.json') as json_file:
      config = json.load(json_file)
      try:
        self.powerline.append(" g:%s " % config['ResourceGroup']['Name'],
          self.powerline.theme.IBMCLOUD_GROUP_FG,
          self.powerline.theme.IBMCLOUD_GROUP_BG)
      except:
        pass
      try:
        self.powerline.append(" r:%s " % config['Region'],
          self.powerline.theme.IBMCLOUD_REGION_FG,
          self.powerline.theme.IBMCLOUD_REGION_BG)
      except:
        pass
    
    with open('/root/.bluemix/.cf/config.json') as json_file:
      config = json.load(json_file)
      try:
        self.powerline.append(" o:%s " % config['OrganizationFields']['Name'],
          self.powerline.theme.IBMCLOUD_ORG_FG,
          self.powerline.theme.IBMCLOUD_ORG_BG)
      except:
        pass
      try:
        self.powerline.append(" s:%s " % config['SpaceFields']['Name'],
          self.powerline.theme.IBMCLOUD_SPACE_FG,
          self.powerline.theme.IBMCLOUD_SPACE_BG)
      except:
        pass
