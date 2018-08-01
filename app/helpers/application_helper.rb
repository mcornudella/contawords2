module ApplicationHelper
    
    def bootstrap_class_for flash_type
        case flash_type
            when :success
            "alert-success"
            when :error
            "alert-error"
            when :alert
            "alert-block"
            when :notice
            "alert-info"
            else
            "else-alert"
            #flash_type.to_s
        end
    end

    def lang_selector
        select_tag :language, options_for_select(I18n.available_locales.to_a.map{ |locale| [t('name', :locale => locale), locale] }, I18n.locale.to_sym)
    end
    
    def hidden_if condition
        " hidden " if condition
    end
    
    def humanize_lang(lang)
        case lang
            when "es" then t(:spanish)
            when "en" then t(:english)
            when "ca" then t(:catalan)
            when "pt" then t(:portuguese)
            when "it" then t(:italian)
        end
    end
    
    def lang_options
        [[t(:tell_document_lang), ""]] +  %w{es en ca pt it}.map { |lang| [humanize_lang(lang), lang] }
    end
end
