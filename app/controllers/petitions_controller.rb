class PetitionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_petition, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  
  # GET /petitions or /petitions.json
  def index
    @petitions = Petition.all
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

    respond_to do |format|
      if @petition.save
        format.html { redirect_to petition_url(@petition), notice: "Petition was successfully created." }
        format.json { render :show, status: :created, location: @petition }
      else
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

    # def set_user
    #   @user = current_user
    # end
    # Use callbacks to share common setup or constraints between actions.
    def set_petition
      @petition = Petition.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def petition_params
      params.require(:petition).permit(:title, :description)
    end
end
