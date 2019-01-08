RSpec.describe Sekrat::Warehouse::FileSystem do
  it "has a version number" do
    expect(Sekrat::Warehouse::FileSystem::VERSION).not_to be nil
  end

  let(:basedir) {'/var/lib/secrets'}
  let(:warehouse) {described_class.new(basedir: basedir)}

  describe '#ids' do
    let(:ids) {warehouse.ids}

    context 'when there are no secrets stored' do
      it 'is empty' do
        expect(ids).to be_empty
      end

    end

    context 'when there are stored secrets' do
      let(:id) {'secret_id'}

      before(:each) do
        MemFs.touch(File.join(basedir, id))
      end

      it 'contains the known secret IDs' do
        expect(ids).to include(id)
      end
    end
  end

  describe '#store' do
    let(:id) {'store/test'}
    let(:data) {'my sausages turned to gold!'}

    context 'when all goes well' do
      context 'and the secret is not already stored' do
        it 'saves the data' do
          warehouse.store(id, data)

          result = Base64.decode64(File.read(File.join(basedir, id)))

          expect(result).to eql(data)
        end
      end

      context 'and the secret is already stored' do
        let(:newdata) {'oh what a lovely bunch of bananas!'}

        before(:each) do
          warehouse.store(id, data)
        end

        it 'overwrites the secret' do
          expect(Base64.decode64(File.read(File.join(basedir, id)))).to eql(data)

          warehouse.store(id, newdata)

          secret = Base64.decode64(File.read(File.join(basedir, id)))
          expect(secret).to eql(newdata)
        end
      end
    end

    context 'when there are issues along the way' do
      before(:each) do
        expect(warehouse).to receive(:filename).and_raise("heckin heck")
      end

      it 'raises an error' do
        expect {warehouse.store(id, data)}.to raise_error(Sekrat::StorageFailure)
      end
    end
  end

  describe '#retrieve' do
    let(:id) {'retrieve/test'}
    let(:data) {'i am so incredibly secret'}
    let(:retrieve) {warehouse.retrieve(id)}

    context 'when the secret is not stored' do
      it 'raises an error' do
        expect {retrieve}.to raise_error(Sekrat::NotFound)
      end
    end

    context 'when the secret is stored' do
      before(:each) do
        warehouse.store(id, data)
      end

      context 'but there is a problem reading it' do
        before(:each) do
          allow(File).to receive(:read).and_raise("onoes")
        end

        it 'raises an error' do
          expect {retrieve}.to raise_error(Sekrat::Error)
        end
      end

      context 'and all goes well' do
        it 'is the secret data' do
          expect(retrieve).to eql(data)
        end
      end
    end
  end
end
