CREATE TABLE dailies (
  'id' INT UNSIGNED NOT NULL AUTO_INCREMENT,
  'daily_date' date,
  'system_down_time' INT UNSIGNED,
  'log_image_count' INT UNSIGNED,
  'copyright_problems' INT UNSIGNED,
  'project' varchar( 50 ),
  'books_done_this_period' INT UNSIGNED,
  'jobs_created_this_fiscal_year' INT UNSIGNED,
  'jobs_approved_this_period' INT UNSIGNED,
  'jobs_active_this_fiscal_year' INT UNSIGNED,
  'jobs_killed_this_period' INT UNSIGNED,
  'at_scan' INT UNSIGNED,
  'at_select_file_move_destination' INT UNSIGNED,
  'at_batch' INT UNSIGNED,
  'at_touchup' INT UNSIGNED,
  'at_quality_control' INT UNSIGNED,
  'at_move_to_precopy_node' INT UNSIGNED,
  'at_moveprocessingfiles' INT UNSIGNED,
  'at_movefilestoarchival' INT UNSIGNED,
  'at_movefoldoutstoarchival' INT UNSIGNED,
  'at_standard_pages_ingest_script' INT UNSIGNED,
  'at_book_builder' INT UNSIGNED,
  'at_associate_rescans' INT UNSIGNED,
  'at_confirm_foldouts_done' INT UNSIGNED,
  'at_import_foldouts' INT UNSIGNED,
  'at_foldout_ingest_script' INT UNSIGNED,
  'at_approve' INT UNSIGNED,
  'at_pdf_generation_script' INT UNSIGNED,
  UNIQUE idx_date_project ( daily_date, project )
);