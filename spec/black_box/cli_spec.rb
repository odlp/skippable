RSpec.describe "Skippable" do
  let(:session) { JetBlack::Session.new }

  it "only runs a command if the specified files changed" do
    session.create_file ".skippable.yml", <<~YAML
      tasks:
        expensive_op:
          command: echo "slow zzz"
          paths:
            - lockfile_a
            - lockfile_b
    YAML

    session.create_file("lockfile_a", "initial state")
    session.create_file("lockfile_b", "initial state II")

    expect(session.run("skippable expensive_op")).
      to be_a_success.and have_stdout(/slow zzz/)

    expect(session.run("skippable expensive_op")).
      to be_a_success.and have_stdout(/Skipping expensive_op/)

    session.append_to_file("lockfile_b", "changes")

    expect(session.run("skippable expensive_op")).
      to be_a_success.and have_stdout(/slow zzz/)
  end

  it "does not skip a command if the previous invocation failed" do
    session.create_file ".skippable.yml", <<~YAML
      tasks:
        broken_op:
          command: echo "kaboom" && exit 2
          paths:
            - lockfile
    YAML

    session.create_file("lockfile", "initial state")

    expect(session.run("skippable broken_op")).
      to be_a_failure.and have_stdout(/kaboom/)

    expect(session.run("skippable broken_op")).
      to be_a_failure.and have_stdout(/kaboom/)
  end
end
