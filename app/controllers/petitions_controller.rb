class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_petition, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  
  # GET /petitions or /petitions.json
  def index
    @search = Petition.includes(:user).where(status: :approved).ransack(params[:q]) # Obywatele widzą tylko zatwierdzone petycje
    @petitions = @search.result(distinct: true).page(params[:page])
    #@popular_petitions = Petition.where(status: :approved).order(signatures_count: :desc).limit(5) # Najczęściej podpisywane petycje
    @my_petitions = current_user.petitions.page(params[:my_page]) # Petycje użytkownika
  end

  # GET /petitions/1 or /petitions/1.json
  def show
  end

  # GET /petitions/new
  def new
    # @petition = @user.petitions.new
    @petition = current_user.petitions.new
  end

  # GET /petitions/1/edit
  def edit
  end

  # POST /petitions or /petitions.json
  def create
    # @petition = @user.petitions.new(petition_params)
    @petition = current_user.petitions.new(petition_params)
    @petition.status = "pending"
    @petition.signature_goal ||= Petition::MIN_SIGNATURES_FOR_REVIEW if @petition.requires_signatures?

    respond_to do |format|
      if @petition.save
        format.html { redirect_to petition_url(@petition), notice: "Petition was successfully created." }
        format.json { render :show, status: :created, location: @petition }
      else
        Rails.logger.debug "Validation errors: #{@petition.errors.full_messages.join(', ')}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /petitions/1 or /petitions/1.json
  def update
    respond_to do |format|
      if @petition.update(petition_params)
        format.html { redirect_to petition_url(@petition), notice: "Petition was successfully updated." }
        format.json { render :show, status: :ok, location: @petition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @petition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /petitions/1 or /petitions/1.json
  def destroy
    @petition.destroy!

    respond_to do |format|
      format.html { redirect_to petitions_url, notice: "Petition was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_petition
      @petition = Petition.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def petition_params
      params.require(:petition).permit(:title, :description, :category, :subcategory, :address, :recipient, :justification, :signature_goal, :privacy_policy, :end_date, :public_comment, :attachment, :external_links, :priority, :comments, :gdpr_consent, :petition_type)
    end
    
end
