import _01_log_parser
import sys
import os.path
import time 


class ProsecLogParserManager:

    def __init__(self, context = None):
        self.log_parsers = []
        # a reserved property for future use. 
        self.context = context
        pass 

    # The context is reserved for future use, if the program 
    # needs to pass some context to the manager. 
    def get_context(self):
        return self.context 


    def set_context(self, context = None):
        self.context = context 

    # Log type could be: 
    #   kernel  :   for kernel.log 
    #   notice  :   for notice.log - ssh/telnet parse
    #   scan    :   for notice.log - scanning parse
    def make_log_parser(self, log_file, log_type):
        fp = open(log_file)
        if "kernel" == log_type:
            parser = _01_log_parser.ProsecKernelLogParser(fp)
        elif "notice" == log_type:
            parser = _01_log_parser.ProsecNoticeLogParser(fp)
        elif "scan" == log_type:
            parser = _01_log_parser.ProsecScanLogParser(fp)
        else:
            parser = None 
            print("[00_controller]: wrong log_type")

        if None != parser: 
            self.add_log_parser(parser)
        

    # The passed in log_parser should be an object 
    # of ProsecLogParser or its subclasses. 
    def add_log_parser(self, log_parser):
        self.log_parsers.append(log_parser)


    def flush_log_parsers(self):
        for parser in self.log_parsers:
            parser.parse()


    def destroy_log_parsers(self):
        for parser in self.log_parsers: 
            parser.destroy()





if __name__ == "__main__":

    if ( len(sys.argv) != 3):
        print("Usage: " + sys.argv[0] + " <notice.log> <kernel.log> ")
        exit(1)

    
    kernel_log = sys.argv[1]
    notice_log = sys.argv[2]
    is_running = "is_running_controller_00.txt"
    is_terminating = "is_terminating_controller_00.txt"

    with open(is_running, 'w') as fp:
        pass 
    
    if os.path.exists(is_terminating):
        os.remove(is_terminating)

    kernel_log_available = False 
    notice_log_available = False
    parser_manager = ProsecLogParserManager()

    # Main loop 
    # To terminate this loop, create a file named is_terminating_controller_00.txt 
    # And at the same time, remove  is_running_controller_00.txt
    while True: 
        if os.path.exists(is_running) and not os.path.exists(is_terminating):
            # check log availability 
            if not kernel_log_available:
                # print("[00_controller]: kernel.log not found ! ")
                if os.path.exists(kernel_log):
                    kernel_log_available = True 
                    print("[00_controller]: Making parser for kernel.log ... ")
                    parser_manager.make_log_parser(kernel_log, "kernel")

            if not notice_log_available:
                # print("[00_controller]: notice.log not found ! ")
                if os.path.exists(notice_log):
                    notice_log_available = True
                    print("[00_controller]: Making parser for notice.log ... ")
                    parser_manager.make_log_parser(notice_log, "notice")
                    parser_manager.make_log_parser(notice_log, "scan")
                    
            # open and follow available logs 
            parser_manager.flush_log_parsers()
            time.sleep(0.01)
        else:
            break


    # You should destroy all parsers. 
    print("[00_controller]: Destroy all parsers ... ")
    parser_manager.destroy_log_parsers()

