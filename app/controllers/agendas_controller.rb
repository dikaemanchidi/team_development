class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end


  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end
  def destroy
     @agenda =Agenda.find(params[:id])
       respond_to do |format|
         if @agenda.destroy && (current_user.id == @agenda.user_id || current_user.id == @agenda.team.owner_id)
          NoticeMailer.agenda_remove_mail(@agenda.team.members.pluck(:email),current_user,@agenda).deliver
         format.html { redirect_to dashboard_url, notice: 'agender was successfully destroyed.' }
         format.json { head :no_content }
       else
        redirect_to  dashboard_path,  notice: " Agenda fialed to delete"
       end
     end
   end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end