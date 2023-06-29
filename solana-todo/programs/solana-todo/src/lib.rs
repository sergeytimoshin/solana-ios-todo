use anchor_lang::prelude::*;

declare_id!("AaCX2J9gPgujGg5xsNhvPuziJpQvWoXd5HrQj26c2ep3");

#[program]
pub mod solana_todo {
    use super::*;

    pub fn add_todo(ctx: Context<AddTodo>, content: String) -> Result<()> {        
        require!(content.chars().count() < 300, ErrorCode::ContentTooLong);
        
        let todo: &mut Account<STodo> = &mut ctx.accounts.todo;
        let clock: Clock = Clock::get().unwrap();
        
        todo.timestamp = clock.unix_timestamp;
        todo.content = content;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct AddTodo<'info> {
    #[account(init, payer = user, space = STodo::LEN)]
    pub todo: Account<'info, STodo>,
    #[account(mut)]
    pub user: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[account]
pub struct STodo {
    pub timestamp: i64,
    pub content: String,
    pub is_finished: bool,
}

const DISCRIMINATOR_LENGTH: usize = 8;
const TIMESTAMP_LENGTH: usize = 8;
const STRING_LENGTH_PREFIX: usize = 4;
const MAX_CONTENT_LENGTH: usize = 300 * 4;
const IS_FINISHED_LENGTH: usize = 8;

impl STodo {
    const LEN: usize = DISCRIMINATOR_LENGTH
        + TIMESTAMP_LENGTH
        + STRING_LENGTH_PREFIX + MAX_CONTENT_LENGTH 
        + IS_FINISHED_LENGTH;
}

#[error_code]
pub enum ErrorCode {
    #[msg("The provided topic should be 300 characters long maximum.")]
    ContentTooLong,
}