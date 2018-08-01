class HomeController < ApplicationController
    def index
        render :layout => 'home'
    end
    
    def more_info
        render :layout => 'application'
    end
    
    def faq
        render :layout => 'application'
    end
    
    def credits
        render :layout => 'application'
    end
end
