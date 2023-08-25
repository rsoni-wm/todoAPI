require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  context 'GET /tasks' do
    before(:each) do
      FactoryBot.create(:task, title: 'meeting at 10 AM', description: 'Sprint Planning meeting', tags: ['work'],status: "start")
      FactoryBot.create(:task, title: 'submit assignment', description: 'Submit practice assignment', tags: ['assignment', 'work'], status: "finish")
    end

    it 'returns all tasks' do
      get '/tasks'
      puts response.status
      puts response.body

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end

    it 'returns task records for specific tag' do
      get '/tasks/searchby_tag/assignment'

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  context 'POST /tasks' do
    it 'creates a new task' do

      expect {
        post '/tasks', params: { task: { title: 'Client Call',description:"Client is Calling" ,tags: ['call', 'work'] ,status:"finish" } }
      }.to change { Task.count }.from(4).to(5)
      puts "Task count after: #{Task.count}"

      expect(response).to have_http_status(:created)
    end


    it 'does not create a task without title' do
      post '/tasks', params: { task: { title: '', tags: ['call', 'work'] } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'PUT /tasks/:id' do
    let!(:task) {   FactoryBot.create(:task, title: 'meeting at 10 AM') }

    it 'updates the existing task with the given task id' do
      put "/tasks/#{task.id}", params: { task: { title: 'Client Call' } }

      expect(response).to have_http_status(:success)
    end

    it 'does not update the task for non-existing task' do
      expect { put "/tasks/12" }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  context 'GET /tasks/:id' do
    let!(:task) {  FactoryBot.create(:task, title: 'meeting at 10 AM') }

    it 'shows a task detail for an existing task' do
      get "/tasks/#{task.id}"

      expect(response).to have_http_status(:success)
    end

    it 'does not show task detail for non-existing task' do
      expect { get "/tasks/12" }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  context 'DELETE /tasks/:id' do
    let!(:task) { FactoryBot.create(:task, title: 'meeting at 10 AM') }
    puts "Task count before: #{Task.count}"

    it 'deletes a task' do
      task_count_before = Task.count

      delete "/tasks/#{task.id}"

      expect(Task.count).to eq(task_count_before)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'RESTORE deleted /tasks/:id/restore' do
    let!(:task) { FactoryBot.create(:task, title: 'meeting at 10 AM') }

    it 'restores a deleted task' do
      delete "/tasks/#{task.id}"
      deleted_task_count = Task.count

      put "/tasks/#{task.id}/restore"
      restored_task_count = Task.count

      expect(deleted_task_count).to eq(11)
      expect(restored_task_count).to eq(11)
      expect(response).to have_http_status(:ok)
    end
  end

end
