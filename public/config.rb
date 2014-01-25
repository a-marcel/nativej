# Require any additional compass plugins here.

main_path = File.dirname(__FILE__)

# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "stylesheets"
sass_dir = "sass"
images_dir = "images"
fonts_dir = "fonts"
javascripts_dir = "javascripts"
sprite_load_path = File.join(main_path, "images/sprites/")



http_fonts_path= http_path + fonts_dir

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
line_comments = false

#output_style = :compressed


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
preferred_syntax = :scss

# Make a copy of sprites with a name that has no uniqueness of the hash.
on_sprite_saved do |filename|
    if File.exists?(filename)
        FileUtils.cp filename, filename.gsub(%r{-s[a-z0-9]{10}\.png$}, '.png')
#        FileUtils.rm filename
    end
end

on_stylesheet_saved do |filename|
    if File.exists?(filename)
        css = File.read filename
        File.open(filename, 'w+') do |f|
            f << css.gsub(%r{-s[a-z0-9]{10}\.png}, '.png')
        end
    end
end
