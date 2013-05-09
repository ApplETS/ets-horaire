# encoding: UTF-8

require_relative '../../app/etsmtl/extract_prerequisites'

describe ExtractPrerequisites do

  context '(MAT145)' do
    let(:prerequisites) { ExtractPrerequisites.from('(MAT145)') }
    let(:mat145) { double }
    let(:and_relation) { double }

    before(:each) do
      ExtractPrerequisites::Course.should_receive(:new).once.with('MAT145', :prerequisite).and_return mat145
      ExtractPrerequisites::Relation.should_receive(:new).once.with(:and, [mat145]).and_return and_relation
    end

    it 'should return MAT145 as a prerequisite' do
      prerequisites.should == and_relation
    end
  end

  context '(CTN504*)' do
    let(:prerequisites) { ExtractPrerequisites.from('(CTN504*)') }
    let(:ctn504) { double }
    let(:and_relation) { double }

    before(:each) do
      ExtractPrerequisites::Course.should_receive(:new).once.with('CTN504', :prerequisite_or_concurrent).and_return ctn504
      ExtractPrerequisites::Relation.should_receive(:new).once.with(:and, [ctn504]).and_return and_relation
    end

    it 'should return CTN504 as a prerequisite or a concurrent course' do
      prerequisites.should == and_relation
    end
  end

  context '(CTN308, MAT165)' do
    let(:prerequisites) { ExtractPrerequisites.from('(CTN308, MAT165)') }
    let(:ctn308) { double }
    let(:mat165) { double }
    let(:and_relation) { double }

    before(:each) do
      ExtractPrerequisites::Course.should_receive(:new).once.with('CTN308', :prerequisite).and_return ctn308
      ExtractPrerequisites::Course.should_receive(:new).once.with('MAT165', :prerequisite).and_return mat165
      ExtractPrerequisites::Relation.should_receive(:new).once.with(:and, [ctn308, mat165]).and_return and_relation
    end

    it 'should return CTN308 and MAT165 as prerequisites' do
      prerequisites.should == and_relation
    end
  end

  context '(CTN200,GIA400)' do
    let(:prerequisites) { ExtractPrerequisites.from('(CTN200,GIA400)') }
    let(:ctn200) { double }
    let(:gia400) { double }
    let(:and_relation) { double }

    before(:each) do
      ExtractPrerequisites::Course.should_receive(:new).once.with('CTN200', :prerequisite).and_return ctn200
      ExtractPrerequisites::Course.should_receive(:new).once.with('GIA400', :prerequisite).and_return gia400
      ExtractPrerequisites::Relation.should_receive(:new).once.with(:and, [ctn200, gia400]).and_return and_relation
    end

    it 'should return CTN200 and GIA400 as prerequisites' do
      prerequisites.should == and_relation
    end
  end

  context '(INF135, MEC329*)' do
    let(:prerequisites) { ExtractPrerequisites.from('(INF135, MEC329*)') }
    let(:inf135) { double }
    let(:mec329) { double }
    let(:and_relation) { double }

    before(:each) do
      ExtractPrerequisites::Course.should_receive(:new).once.with('INF135', :prerequisite).and_return inf135
      ExtractPrerequisites::Course.should_receive(:new).once.with('MEC329', :prerequisite_or_concurrent).and_return mec329
      ExtractPrerequisites::Relation.should_receive(:new).once.with(:and, [inf135, mec329]).and_return and_relation
    end

    it 'should return INF135 as a prerequisite and MEC329 as a prerequisite or a concurrent course' do
      prerequisites.should == and_relation
    end
  end

  context '(MAT265, MEC222, MEC423)' do
    let(:prerequisites) { ExtractPrerequisites.from('(MAT265, MEC222, MEC423)') }
    let(:mat265) { double }
    let(:mec222) { double }
    let(:mec423) { double }
    let(:and_relation) { double }

    before(:each) do
      ExtractPrerequisites::Course.should_receive(:new).once.with('MAT265', :prerequisite).and_return mat265
      ExtractPrerequisites::Course.should_receive(:new).once.with('MEC222', :prerequisite).and_return mec222
      ExtractPrerequisites::Course.should_receive(:new).once.with('MEC423', :prerequisite).and_return mec423
      ExtractPrerequisites::Relation.should_receive(:new).once.with(:and, [mat265, mec222, mec423]).and_return and_relation
    end

    it 'should return MAT265, MEC222 and MEC423 as prerequisites' do
      prerequisites.should == and_relation
    end
  end

  context '(PCC310 ou PCC317)' do
    let(:prerequisites) { ExtractPrerequisites.from('(PCC310 ou PCC317)') }
    let(:pcc310) { double }
    let(:pcc317) { double }
    let(:or_relation) { double }

    before(:each) do
      ExtractPrerequisites::Course.should_receive(:new).once.with('PCC310', :prerequisite).and_return pcc310
      ExtractPrerequisites::Course.should_receive(:new).once.with('PCC317', :prerequisite).and_return pcc317
      ExtractPrerequisites::Relation.should_receive(:new).once.with(:or, [pcc310, pcc317]).and_return or_relation
    end

    it 'should return PCC310 or PCC317 as a prerequisite' do
      prerequisites.should == or_relation
    end
  end

  context '(GPA205, sauf profil P)' do
  end

  context '(ELE340; profil E: INF145)' do
  end

  context '(profils A et C CTN103)' do
  end

  context '(profils AD, I et R: GOL102)' do
  end

  context '(profils I, M et P : GPA325)' do
  end

  context '(profil B : CTN100; profils A et C : CTN100, CTN103)' do
  end

  context '(profil E : GPA305, ING150; profils I, M et P : ING150)' do
  end

  context '(profils A et B : CHM131, CTN104; profil C : CHM131)' do
  end

  context '(profils A et B : CTN104, CTN308, CTN426; profil C : CTN308, CTN426)' do
  end

  context '(profils E, I et M : GPA205, GPA430; profil P : GPA430)' do
  end

  context '(PCS310 et avoir obtenu au moins 6 crédits de cours dans la concentration Technologies de la santé)' do
  end

  context '(PCS310 et avoir obtenu au moins 6 crédits de cours de la concentration Technologies de la santé)' do
  end

  context '(avoir obtenu au moins 6 crédits de cours de la concentration Technologies de la santé)' do
  end

  context '(90 crédits cumulés)' do
  end
end