require_relative '../spec_helper'
require_relative '../render_shared'

describe 'Lettuce/Python rendering' do
  include HelperFactories

  it_behaves_like 'a BDD renderer', uid_should_be_in_outline: true do
    let(:language) {'lettuce'}
    let(:rendered_actionwords) {
      [
        'from lettuce import *',
        '',
        'import actionwords',
        '',
	'',
        '@step(\'the color "(.*)"\')',
        'def impl(step,color):',
        '    world.actionwords.the_color_color(color)',
        '',
	'',
	'',
        '@step(\'you mix colors\')',
        'def impl(step):',
        '    world.actionwords.you_mix_colors()',
        '',
        '',
	'',
        '@step(\'you obtain "(.*)"\')',
        'def impl(step,color):',
        '    world.actionwords.you_obtain_color(color)',
        '',
        '',
        '',
        '',
	'',
	'',
        '@step(\'you cannot play croquet\')',
        'def impl(step):',
        '    world.actionwords.you_cannot_play_croquet()',
        '',
        '',
	'',
        '@step(\'I am on the "(.*)" home page\')',
        '@step(\'I am on the "(.*)" home page\')',
        'def impl(step,site, free_text = \'\'):',
        '    world.actionwords.i_am_on_the_site_home_page(site, free_text)',
        '',
        '',
	'',
        '@step(\'the following users are available on "(.*)"\')',
        'def impl(step,site, datatable = \'||\'):',
        '    world.actionwords.the_following_users_are_available_on_site(site, datatable)',
        '',
        '',
	'',
        '@step(\'an untrimed action word\')',
        'def impl(step):',
        '    world.actionwords.an_untrimed_action_word()',
        '',
        '',
	'',
        '@step(\'the "(.*)" of "(.*)" is weird "(.*)" "(.*)"\')',
        'def impl(step,order, parameters, p0, p1):',
        '    world.actionwords.the_order_of_parameters_is_weird(p0, p1, parameters, order)',
        '',
        '',
	'',
        '@step(\'I login on "(.*)" "(.*)"\')',
        'def impl(step,site, username):',
        '    world.actionwords.i_login_on(site, username)',
        '',
	'',
	'',
	''
      ].join("\n")
    }

    let(:rendered_free_texted_actionword) {[
      'def the_following_users_are_available(self, free_text = \'\'):',
      '    pass',
      ''].join("\n")}

    let(:rendered_datatabled_actionword) {[
      'def the_following_users_are_available(self, datatable = \'\'):',
      '    pass',
      ''].join("\n")}

    let(:rendered_empty_scenario) { "\nScenario: Empty Scenario\n" }
  end

  it 'strips last colon of an actionword name' do
    # If your action word is called "Do something:", Lettuce will try to match "Do something"
    aw = make_actionword('I do something:')
    project = make_project("Colors",
      scenarios: [
        make_scenario('My scenario',
          body: [
            make_call("I do something:",  annotation: "when")
          ])
      ],
      actionwords: [aw]
    )
    Hiptest::GherkinAdder.add(project)

    options =  context_for(only: "step_definitions", language: 'lettuce')
    expect(aw.render(options)).to eq([
      "",
      "@step('I do something')",
      "def impl(step):",
      "    world.actionwords.i_do_something()",
      ""
    ].join("\n"))
  end
end
