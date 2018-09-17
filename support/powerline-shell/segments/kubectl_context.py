import subprocess
from powerline_shell.utils import ThreadedSegment

class Segment(ThreadedSegment):
  def run(self):
    try:
      p1 = subprocess.Popen(["kubectl", "config", "current-context"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
      self.context = p1.communicate()[0].decode("utf-8").rstrip()
    except OSError:
      self.context = None

  def add_to_powerline(self):
    self.join()
    if not self.context:
      return

    self.powerline.append(" " + u'\u2638' + " " + self.context + " ",
      self.powerline.theme.IBMCLOUD_KUBECTL_CONTEXT_FG, 
      self.powerline.theme.IBMCLOUD_KUBECTL_CONTEXT_BG)
