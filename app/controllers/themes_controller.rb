class ThemesController < ApplicationController
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  # GET /themes
  # GET /themes.json
  def index
    @themes = Theme.all

    respond_to do |format|
      format.jpg {
        @theme = current_tenant.theme
        render_preview_snapshot
      }
      format.html
    end
  end

  # GET /themes/1
  # GET /themes/1.json
  def show
  end

  # GET /themes/new
  def new
    @theme = Theme.new
  end

  # GET /themes/1/edit
  def edit
  end

  # POST /themes
  # POST /themes.json
  def create
    @theme = Theme.new(theme_params)

    respond_to do |format|
      if @theme.save
        %x(bundle exec rake tmp:cache:clear)
        format.html { redirect_to @theme, notice: 'Theme was successfully created.' }
        format.json { render :show, status: :created, location: @theme }
      else
        format.html { render :new }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /themes/1
  # PATCH/PUT /themes/1.json
  def update
    @theme = Theme.find(params[:id])
    if params[:commit] == "Preview"
      set_instance_variables_for_snapshot
      save_preview_snapshot
      respond_to do |format| 
        format.js { render :file => "/app/views/themes/preview.js.erb" }
      end
    elsif @theme.update(theme_params)
      %x(bundle exec rake tmp:cache:clear)
      flash[:notice] = 'Theme was successfully updated.'
    else
      render :file => "/app/views/themes/update_fail.js.erb"
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.json
  def destroy
    @theme.destroy
    respond_to do |format|
      format.html { redirect_to themes_url, notice: 'Theme was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme
      @theme = Theme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def theme_params
      params.require(:theme).permit(:tenant_id, :font_color)
    end

    def save_preview_snapshot
      create_preview_snapshot
      @kit.to_file("#{Rails.root}/app/assets/images/preview/#{current_tenant.subdomain}_preview.jpg")
    end

    def render_preview_snapshot
      create_preview_snapshot
      send_data(@kit.to_jpg, :type => "image/jpg", :disposition => 'inline')
    end

    def create_preview_snapshot
      Theme.compile_css_for_preview(current_tenant.subdomain, @theme)
      html = render_to_string(:action => "index.html.erb", :layout => '/layouts/application.html.erb')
      @kit = IMGKit.new(html, :quality => 50)
      @kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/preview/#{current_tenant.subdomain}_preview.css"
    end

    def set_instance_variables_for_snapshot
      @theme.assign_attributes(theme_params)
      @themes = Theme.all
      @subdomain = current_tenant.subdomain
    end
end
