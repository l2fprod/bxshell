from powerline_shell.utils import BasicSegment
import os
import json

class Segment(BasicSegment):
  def add_to_powerline(self):
    with open('/root/.bluemix/config.json') as json_file:
      config = json.load(json_file)
      try:
        self.powerline.append(" r:%s " % config['Region'],
          self.powerline.theme.IBMCLOUD_REGION_FG,
          self.powerline.theme.IBMCLOUD_REGION_BG)
      except:
        pass
