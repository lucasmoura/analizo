package MetricAccmTests;
use base qw(Test::Class);
use Test::More 'no_plan'; # REMOVE THE 'no_plan'

use strict;
use warnings;
use File::Basename;

use Analizo::Model;
use Analizo::Metric::AverageCycloComplexity;

eval('$Analizo::Metric::QUIET = 1;'); # the eval is to avoid Test::* complaining about possible typo

use vars qw($model $accm);

sub setup : Test(setup) {
  $model = new Analizo::Model;
  $accm = new Analizo::Metric::AverageCycloComplexity(model => $model);
}

sub use_package : Tests {
  use_ok('Analizo::Metric::AverageCycloComplexity');
}

sub has_model : Tests {
  is($accm->model, $model);
}

sub description : Tests {
  is($accm->description, "Average Cyclomatic Complexity per Method");
}

sub calculate : Tests {
  $model->declare_module('module');
  is($accm->calculate('module'), 0, 'no function');

  $model->declare_function('module', 'module::function');
  $model->add_conditional_paths('module::function', 3);
  is($accm->calculate('module'), 3, 'one function with three conditional paths');

  $model->declare_function('module', 'module::function1');
  $model->add_conditional_paths('module::function1', 2);
  $model->declare_function('module', 'module::function2');
  $model->add_conditional_paths('module::function2', 4);
  is($accm->calculate('module'), 3, 'two function with three average cyclomatic complexity per method');
}

MetricAccmTests->runtests;

